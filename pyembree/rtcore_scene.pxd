# rtcore_scene.pxd wrapper

cimport cython
cimport numpy as np
cimport rtcore as rtc
cimport rtcore_ray as rtcr

cdef extern from "embree3/rtcore_scene.h":
    """
    struct RTCIntersectContext* createContext(){
      return (struct RTCIntersectContext*) malloc(sizeof(struct RTCIntersectContext));
    };
    
    void deleteContext(struct RTCIntersectContext* context){
      free(context);
    }
    """

    ctypedef struct RTCRayHit
    ctypedef struct RTCRayHit4
    ctypedef struct RTCRayHit8
    ctypedef struct RTCRayHit16

    ctypedef struct RTCRay
    ctypedef struct RTCRay4
    ctypedef struct RTCRay8
    ctypedef struct RTCRay16

    cdef enum RTCSceneFlags:
        RTC_SCENE_FLAG_NONE
        RTC_SCENE_FLAG_DYNAMIC
        RTC_SCENE_FLAG_COMPACT
        RTC_SCENE_FLAG_ROBUST
        RTC_SCENE_FLAG_CONTEXT_FILTER_FUNCTION

    cdef enum RTCAlgorithmFlags:
        RTC_INTERSECT1
        RTC_INTERSECT4
        RTC_INTERSECT8
        RTC_INTERSECT16

    cdef enum RTCIntersectContextFlags:
        RTC_INTERSECT_CONTEXT_FLAG_NONE
        RTC_INTERSECT_CONTEXT_FLAG_INCOHERENT
        RTC_INTERSECT_CONTEXT_FLAG_COHERENT

    cdef struct RTCFilterFunctionNArguments

    ctypedef void (*RTCFilterFunctionN)(const RTCFilterFunctionNArguments* args);

    cdef struct RTCIntersectContext

    RTCIntersectContext* createContext();
    void deleteContext(RTCIntersectContext* context)
    void rtcInitIntersectContext(RTCIntersectContext* context)

    # ctypedef void* RTCDevice
    ctypedef void* RTCScene

    RTCScene rtcNewScene(rtc.RTCDevice device)

    ctypedef bint (*RTCProgressMonitorFunc)(void* ptr, const double n)

    void rtcSetProgressMonitorFunction(RTCScene scene, RTCProgressMonitorFunc func, void* ptr)

    void rtcCommitScene(RTCScene scene)

    void rtcCommitThread(RTCScene scene, unsigned int threadID, unsigned int numThreads)

    void rtcIntersect1(RTCScene scene, RTCIntersectContext* context, RTCRayHit* ray)

    void rtcIntersect4(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRayHit4* ray)

    void rtcIntersect8(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRayHit8* ray)

    void rtcIntersect16(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRayHit16* ray)

    void rtcOccluded1(RTCScene scene, RTCIntersectContext* context, RTCRay* ray)

    void rtcOccluded4(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRay4* ray)

    void rtcOccluded8(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRay8* ray)

    void rtcOccluded16(const void* valid, RTCScene scene, RTCIntersectContext* context, RTCRay16* ray)

    void rtcReleaseScene(RTCScene scene)

    void rtcUpdate(RTCScene scene, unsigned int geomID)


cdef class EmbreeScene:
    cdef RTCScene scene_i
    # Optional device used if not given, it should be as input of EmbreeScene
    cdef public int is_committed
    cdef rtc.EmbreeDevice device
    cdef RTCIntersectContext* context

cdef enum rayQueryType:
    intersect,
    occluded,
    distance

