#!/usr/bin/env python

from setuptools import setup, find_packages

import numpy as np
from Cython.Build import cythonize

include_path = [np.get_include(),'/usr/local/lib','/usr/local/include/embree3/']

ext_modules = cythonize('pyembree/*.pyx', language='c++',
                        include_path=include_path)
for ext in ext_modules:
    ext.include_dirs = include_path
    ext.libraries = ["embree3"]

setup(
    name="pyembree",
    version='0.2.0',
    ext_modules=ext_modules,
    zip_safe=False,
    packages=find_packages(),
    package_data = {'pyembree': ['*.pxd']}
)
