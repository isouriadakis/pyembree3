cimport cython
cimport numpy as np
import numpy as np
import logging
import numbers
cimport rtcore as rtc
cimport rtcore_ray as rtcr
cimport rtcore_geometry as rtcg


log = logging.getLogger('pyembree')

cdef void error_printer(void* userPtr, const rtc.RTCError code, const char *_str):
    """
    error_printer function depends on embree version
    Embree 2.14.1
    -> cdef void error_printer(const rtc.RTCError code, const char *_str):
    Embree 2.17.1
    -> cdef void error_printer(void* userPtr, const rtc.RTCError code, const char *_str):
    """
    log.error("ERROR CAUGHT IN EMBREE")
    rtc.print_error(code)
    log.error("ERROR MESSAGE: %s" % _str)


cdef class EmbreeScene:
    def __init__(self, rtc.EmbreeDevice device=None):
        if device is None:
            # We store the embree device inside EmbreeScene to avoid premature deletion
            self.device = rtc.EmbreeDevice()
            device = self.device
        else:
            # Also in this case as the Google garbage collector deletes it before the scene otherwise
            self.device = device
        rtc.rtcSetDeviceErrorFunction(device.device, error_printer, NULL)
        self.scene_i = rtcNewScene(device.device)
        self.is_committed = 0
        self.context = createContext()
        rtcInitIntersectContext(self.context)

    def run(self, np.ndarray[np.float32_t, ndim=2] vec_origins,
                  np.ndarray[np.float32_t, ndim=2] vec_directions,
                  dists=None,query='INTERSECT',output=None):

        if self.is_committed == 0:
            rtcCommitScene(self.scene_i)
            self.is_committed = 1

        cdef int nv = vec_origins.shape[0]
        cdef int vo_i, vd_i, vd_step
        cdef np.ndarray[np.int32_t, ndim=1] intersect_ids
        cdef np.ndarray[np.float32_t, ndim=1] tfars
        cdef rayQueryType query_type

        if query == 'INTERSECT':
            query_type = intersect
        elif query == 'OCCLUDED':
            query_type = occluded
        elif query == 'DISTANCE':
            query_type = distance

        else:
            raise ValueError("Embree ray query type %s not recognized."
                "\nAccepted types are (INTERSECT,OCCLUDED,DISTANCE)" % (query))

        if dists is None:
            tfars = np.empty(nv, 'float32')
            tfars.fill(1e37)
        elif isinstance(dists, numbers.Number):
            tfars = np.empty(nv, 'float32')
            tfars.fill(dists)
        else:
            tfars = dists

        if output:
            u = np.empty(nv, dtype="float32")
            v = np.empty(nv, dtype="float32")
            Ng = np.empty((nv, 3), dtype="float32")
            primID = np.empty(nv, dtype="int32")
            geomID = np.empty(nv, dtype="int32")
        else:
            intersect_ids = np.empty(nv, dtype="int32")

        cdef rtcr.RTCRayHit ray
        vd_i = 0
        vd_step = 1
        # If vec_directions is 1 long, we won't be updating it.
        if vec_directions.shape[0] == 1: vd_step = 0

        for i in range(nv):
            ray.ray.org_x = vec_origins[i, 0]
            ray.ray.org_y = vec_origins[i, 1]
            ray.ray.org_z = vec_origins[i, 2]
            ray.ray.dir_x = vec_directions[vd_i, 0]
            ray.ray.dir_y = vec_directions[vd_i, 1]
            ray.ray.dir_z = vec_directions[vd_i, 2]
            ray.ray.tnear = 0.0
            ray.ray.tfar = tfars[i]
            ray.hit.geomID = rtcg.RTC_INVALID_GEOMETRY_ID
            ray.hit.primID = rtcg.RTC_INVALID_GEOMETRY_ID
            ray.hit.instID[0] = rtcg.RTC_INVALID_GEOMETRY_ID
            ray.ray.mask = -1
            ray.ray.time = 0
            vd_i += vd_step

            if query_type == intersect or query_type == distance:
                rtcIntersect1(self.scene_i, self.context, &ray)
                if not output:
                    if query_type == intersect:
                        intersect_ids[i] = ray.hit.primID
                    else:
                        tfars[i] = ray.ray.tfar
                else:
                    primID[i] = ray.hit.primID
                    geomID[i] = ray.hit.geomID
                    u[i] = ray.hit.u
                    v[i] = ray.hit.v
                    tfars[i] = ray.ray.tfar

                    Ng[i, 0] = ray.hit.Ng_x
                    Ng[i, 1] = ray.hit.Ng_y
                    Ng[i, 2] = ray.hit.Ng_z
            else:
                rtcOccluded1(self.scene_i, self.context, &ray.ray)
                intersect_ids[i] = ray.hit.geomID

        if output:
            return {'u':u, 'v':v, 'Ng': Ng, 'tfar': tfars, 'primID': primID, 'geomID': geomID}
        else:
            if query_type == distance:
                return tfars
            else:
                return intersect_ids

    def __dealloc__(self):
        deleteContext(self.context)
        rtcReleaseScene(self.scene_i)

