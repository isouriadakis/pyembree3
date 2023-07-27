# rtcore_ray.pxd wrapper

cimport cython
cimport numpy as np
cimport rtcore as rtc

cdef extern from "embree3/rtcore_ray.h":
    # RTCORE_ALIGN(16)
    # This is for a *single* ray
    cdef struct RTCRay:
        # Ray data
        float org_x
        float org_y
        float org_z
        float tnear

        float dir_x
        float dir_y
        float dir_z
        float time

        float tfar
        unsigned mask
        unsigned id
        unsigned flags

    cdef struct RTCHit:
        float Ng_x
        float Ng_y
        float Ng_z

        float u
        float v

        unsigned int primID
        unsigned int geomID
        unsigned int instID[rtc.RTC_MAX_INSTANCE_LEVEL_COUNT]


    cdef struct RTCRayHit:
        RTCRay ray
        RTCHit hit


    cdef struct RTCRay4:
        float org_x[4]
        float org_y[4]
        float org_z[4]
        float tnear[4]

        float dir_x[4]
        float dir_y[4]
        float dir_z[4]
        float time[4]

        float tfar[4]
        unsigned mask[4]
        unsigned id[4]
        unsigned flags[4]

    cdef struct RTCHit4:
        float Ng_x[4]
        float Ng_y[4]
        float Ng_z[4]

        float u[4]
        float v[4]

        unsigned primID[4]
        unsigned geomID[4]
        unsigned instID[rtc.RTC_MAX_INSTANCE_LEVEL_COUNT][4];

    cdef struct RTCRayHit4:
        RTCRay4 ray
        RTCHit4 hit

    cdef struct RTCRay8:
        float org_x[8]
        float org_y[8]
        float org_z[8]
        float tnear[8]

        float dir_x[8]
        float dir_y[8]
        float dir_z[8]
        float time[8]

        float tfar[8]
        unsigned mask[8]
        unsigned id[8]
        unsigned flags[8]

    cdef struct RTCHit8:
        float Ng_x[8]
        float Ng_y[8]
        float Ng_z[8]

        float u[8]
        float v[8]

        unsigned primID[8]
        unsigned geomID[8]
        unsigned instID[rtc.RTC_MAX_INSTANCE_LEVEL_COUNT][8];

    cdef struct RTCRayHit8:
        RTCRay8 ray
        RTCHit8 hit

    cdef struct RTCRay16:
        float org_x[16]
        float org_y[16]
        float org_z[16]
        float tnear[16]

        float dir_x[16]
        float dir_y[16]
        float dir_z[16]
        float time[16]

        float tfar[16]
        unsigned mask[16]
        unsigned id[16]
        unsigned flags[16]

    cdef struct RTCHit16:
        float Ng_x[16]
        float Ng_y[16]
        float Ng_z[16]

        float u[16]
        float v[16]

        unsigned primID[16]
        unsigned geomID[16]
        unsigned instID[rtc.RTC_MAX_INSTANCE_LEVEL_COUNT][16];

    cdef struct RTCRayHit16:
        RTCRay16 ray
        RTCHit16 hit

