# rtcore_geometry wrapper

from rtcore_ray cimport RTCRay, RTCRay4, RTCRay8, RTCRay16
from rtcore_scene cimport RTCScene
cimport cython
cimport numpy as np

cdef extern from "embree3/rtcore_geometry.h":
    cdef unsigned int RTC_INVALID_GEOMETRY_ID

    cdef enum RTCFormat:
        RTC_FORMAT_UNDEFINED

        RTC_FORMAT_UCHAR
        RTC_FORMAT_UCHAR2
        RTC_FORMAT_UCHAR3
        RTC_FORMAT_UCHAR4

        RTC_FORMAT_CHAR
        RTC_FORMAT_CHAR2
        RTC_FORMAT_CHAR3
        RTC_FORMAT_CHAR4

        RTC_FORMAT_USHORT
        RTC_FORMAT_USHORT2
        RTC_FORMAT_USHORT3
        RTC_FORMAT_USHORT4

        RTC_FORMAT_SHORT
        RTC_FORMAT_SHORT2
        RTC_FORMAT_SHORT3
        RTC_FORMAT_SHORT4

        RTC_FORMAT_UINT
        RTC_FORMAT_UINT2
        RTC_FORMAT_UINT3
        RTC_FORMAT_UINT4

        RTC_FORMAT_INT
        RTC_FORMAT_INT2
        RTC_FORMAT_INT3
        RTC_FORMAT_INT4

        RTC_FORMAT_ULLONG
        RTC_FORMAT_ULLONG2
        RTC_FORMAT_ULLONG3
        RTC_FORMAT_ULLONG4

        RTC_FORMAT_LLONG
        RTC_FORMAT_LLONG2
        RTC_FORMAT_LLONG3
        RTC_FORMAT_LLONG4

        RTC_FORMAT_FLOAT
        RTC_FORMAT_FLOAT2
        RTC_FORMAT_FLOAT3
        RTC_FORMAT_FLOAT4
        RTC_FORMAT_FLOAT5
        RTC_FORMAT_FLOAT6
        RTC_FORMAT_FLOAT7
        RTC_FORMAT_FLOAT8
        RTC_FORMAT_FLOAT9
        RTC_FORMAT_FLOAT10
        RTC_FORMAT_FLOAT11
        RTC_FORMAT_FLOAT12
        RTC_FORMAT_FLOAT13
        RTC_FORMAT_FLOAT14
        RTC_FORMAT_FLOAT15
        RTC_FORMAT_FLOAT16

        RTC_FORMAT_FLOAT2X2_ROW_MAJOR
        RTC_FORMAT_FLOAT2X3_ROW_MAJOR
        RTC_FORMAT_FLOAT2X4_ROW_MAJOR
        RTC_FORMAT_FLOAT3X2_ROW_MAJOR
        RTC_FORMAT_FLOAT3X3_ROW_MAJOR
        RTC_FORMAT_FLOAT3X4_ROW_MAJOR
        RTC_FORMAT_FLOAT4X2_ROW_MAJOR
        RTC_FORMAT_FLOAT4X3_ROW_MAJOR
        RTC_FORMAT_FLOAT4X4_ROW_MAJOR

        RTC_FORMAT_FLOAT2X2_COLUMN_MAJOR
        RTC_FORMAT_FLOAT2X3_COLUMN_MAJOR
        RTC_FORMAT_FLOAT2X4_COLUMN_MAJOR
        RTC_FORMAT_FLOAT3X2_COLUMN_MAJOR
        RTC_FORMAT_FLOAT3X3_COLUMN_MAJOR
        RTC_FORMAT_FLOAT3X4_COLUMN_MAJOR
        RTC_FORMAT_FLOAT4X2_COLUMN_MAJOR
        RTC_FORMAT_FLOAT4X3_COLUMN_MAJOR
        RTC_FORMAT_FLOAT4X4_COLUMN_MAJOR

        RTC_FORMAT_GRID


    cdef enum RTCBufferType:
        RTC_BUFFER_TYPE_INDEX
        RTC_BUFFER_TYPE_VERTEX
        RTC_BUFFER_TYPE_VERTEX_ATTRIBUTE
        RTC_BUFFER_TYPE_NORMAL
        RTC_BUFFER_TYPE_TANGENT
        RTC_BUFFER_TYPE_NORMAL_DERIVATIVE

        RTC_BUFFER_TYPE_GRID

        RTC_BUFFER_TYPE_FACE
        RTC_BUFFER_TYPE_LEVEL
        RTC_BUFFER_TYPE_EDGE_CREASE_INDEX
        RTC_BUFFER_TYPE_EDGE_CREASE_WEIGHT
        RTC_BUFFER_TYPE_VERTEX_CREASE_INDEX
        RTC_BUFFER_TYPE_VERTEX_CREASE_WEIGHT
        RTC_BUFFER_TYPE_HOLE

        RTC_BUFFER_TYPE_FLAGS

    cdef enum RTCMatrixType:
        RTC_MATRIX_ROW_MAJOR
        RTC_MATRIX_COLUMN_MAJOR
        RTC_MATRIX_COLUMN_MAJOR_ALIGNED16

    cdef enum RTCGeometryType:
        RTC_GEOMETRY_TYPE_TRIANGLE
        RTC_GEOMETRY_TYPE_QUAD
        RTC_GEOMETRY_TYPE_GRID

        RTC_GEOMETRY_TYPE_SUBDIVISION

        RTC_GEOMETRY_TYPE_CONE_LINEAR_CURVE
        RTC_GEOMETRY_TYPE_ROUND_LINEAR_CURVE
        RTC_GEOMETRY_TYPE_FLAT_LINEAR_CURVE

        RTC_GEOMETRY_TYPE_ROUND_BEZIER_CURVE
        RTC_GEOMETRY_TYPE_FLAT_BEZIER_CURVE
        RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_BEZIER_CURVE

        RTC_GEOMETRY_TYPE_ROUND_BSPLINE_CURVE
        RTC_GEOMETRY_TYPE_FLAT_BSPLINE_CURVE
        RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_BSPLINE_CURVE

        RTC_GEOMETRY_TYPE_ROUND_HERMITE_CURVE
        RTC_GEOMETRY_TYPE_FLAT_HERMITE_CURVE
        RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_HERMITE_CURVE

        RTC_GEOMETRY_TYPE_SPHERE_POINT
        RTC_GEOMETRY_TYPE_DISC_POINT
        RTC_GEOMETRY_TYPE_ORIENTED_DISC_POINT

        RTC_GEOMETRY_TYPE_ROUND_CATMULL_ROM_CURVE
        RTC_GEOMETRY_TYPE_FLAT_CATMULL_ROM_CURVE
        RTC_GEOMETRY_TYPE_NORMAL_ORIENTED_CATMULL_ROM_CURVE

        RTC_GEOMETRY_TYPE_USER
        RTC_GEOMETRY_TYPE_INSTANCE

    cdef struct RTCBounds:
        float lower_x, lower_y, lower_z, align0
        float upper_x, upper_y, upper_z, align1

    ctypedef void* RTCGeometry

    ctypedef void (*RTCFilterFunc)(void* ptr, RTCRay& ray)
    ctypedef void (*RTCFilterFunc4)(void* ptr, RTCRay4& ray)
    ctypedef void (*RTCFilterFunc8)(void* ptr, RTCRay8& ray)
    ctypedef void (*RTCFilterFunc16)(void* ptr, RTCRay16& ray)

    ctypedef void (*RTCDisplacementFunc)(void* ptr, unsigned geomID, unsigned primID,
                                         const float* u, const float* v,
                                         const float* nx, const float* ny, const float* nz,
                                         float* px, float* py, float* pz, size_t N)

    unsigned rtcNewInstance(RTCScene target, RTCScene source)
    void rtcSetTransform(RTCScene scene, unsigned geomID,
                         RTCMatrixType layout, const float *xfm)
    RTCGeometry rtcNewGeometry(RTCScene scene, RTCGeometryType type)

    void rtcSetMask(RTCScene scene, unsigned geomID, int mask)
    void *rtcSetNewGeometryBuffer(RTCGeometry geometry, RTCBufferType type, unsigned slot, RTCFormat format, size_t byteStride, size_t itemCount)
    void *rtcGetGeometryBufferData(RTCGeometry geometry, RTCBufferType type, unsigned slot)
    void rtcUpdateGeometryBuffer(RTCGeometry geometry, RTCBufferType type, unsigned slot)
    void rtcSetBuffer(RTCScene scene, unsigned geomID, RTCBufferType type,
                      void *ptr, size_t offset, size_t stride)
    void rtcCommitGeometry(RTCGeometry geometry);
    void rtcReleaseGeometry(RTCGeometry geometry);
    void rtcEnable(RTCScene scene, unsigned geomID)
    void rtcUpdate(RTCScene scene, unsigned geomID)
    void rtcUpdateBuffer(RTCScene scene, unsigned geomID, RTCBufferType type)
    void rtcDisable(RTCScene scene, unsigned geomID)
    void rtcSetDisplacementFunction (RTCScene scene, unsigned geomID, RTCDisplacementFunc func, RTCBounds* bounds)
    void rtcSetIntersectionFilterFunction (RTCScene scene, unsigned geomID, RTCFilterFunc func)
    void rtcSetIntersectionFilterFunction4 (RTCScene scene, unsigned geomID, RTCFilterFunc4 func)
    void rtcSetIntersectionFilterFunction8 (RTCScene scene, unsigned geomID, RTCFilterFunc8 func)
    void rtcSetIntersectionFilterFunction16 (RTCScene scene, unsigned geomID, RTCFilterFunc16 func)
    void rtcSetOcclusionFilterFunction (RTCScene scene, unsigned geomID, RTCFilterFunc func)
    void rtcSetOcclusionFilterFunction4 (RTCScene scene, unsigned geomID, RTCFilterFunc4 func)
    void rtcSetOcclusionFilterFunction8 (RTCScene scene, unsigned geomID, RTCFilterFunc8 func)
    void rtcSetOcclusionFilterFunction16 (RTCScene scene, unsigned geomID, RTCFilterFunc16 func)
    void rtcSetUserData (RTCScene scene, unsigned geomID, void* ptr)
    void* rtcGetUserData (RTCScene scene, unsigned geomID)
    void rtcDeleteGeometry (RTCScene scene, unsigned geomID)

cdef extern from "embree3/rtcore_scene.h":
    unsigned rtcAttachGeometry(RTCScene scene, RTCGeometry geometry)
    RTCGeometry rtcGetGeometry(RTCScene scene, unsigned geomID)

