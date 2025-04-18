cmake_minimum_required(VERSION 3.0)

set(LibraryName "InferenceHelper")
set(THIRD_PARTY_DIR ${CMAKE_CURRENT_LIST_DIR}/../third_party/)

set(INFERENCE_HELPER_ENABLE_PRE_PROCESS_BY_OPENCV off CACHE BOOL "Enable PreProcess by OpenCV? [on/off]")
set(INFERENCE_HELPER_ENABLE_OPENCV off CACHE BOOL "With OpenCV? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE off CACHE BOOL "With Tflite? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_XNNPACK off CACHE BOOL "With Tflite Delegate XNNPACK? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_GPU off CACHE BOOL "With Tflite Delegate GPU? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_QNN off CACHE BOOL "With Tflite Delegate QNN? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_EDGETPU off CACHE BOOL "With Tflite Delegate EdgeTPU? [on/off]")
set(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_NNAPI off CACHE BOOL "With Tflite Delegate NNAPI? [on/off]")
set(INFERENCE_HELPER_ENABLE_TENSORRT off CACHE BOOL "With TensorRT? [on/off]")
set(INFERENCE_HELPER_ENABLE_NCNN off CACHE BOOL "With Ncnn? [on/off]")
set(INFERENCE_HELPER_ENABLE_MNN off CACHE BOOL "With Mnn? [on/off]")
set(INFERENCE_HELPER_ENABLE_SNPE off CACHE BOOL "With SNPE? [on/off]")
set(INFERENCE_HELPER_ENABLE_ARMNN off CACHE BOOL "With ARMNN? [on/off]")
set(INFERENCE_HELPER_ENABLE_NNABLA off CACHE BOOL "With NNabla? [on/off]")
set(INFERENCE_HELPER_ENABLE_NNABLA_CUDA off CACHE BOOL "With NNabla + CUDA? [on/off]")
set(INFERENCE_HELPER_ENABLE_ONNX_RUNTIME off CACHE BOOL "With ONNX Runtime? [on/off]")
set(INFERENCE_HELPER_ENABLE_ONNX_RUNTIME_CUDA off CACHE BOOL "With ONNX Runtime + CUDA? [on/off]")
set(INFERENCE_HELPER_ENABLE_LIBTORCH off CACHE BOOL "With LibTorch? [on/off]")
set(INFERENCE_HELPER_ENABLE_LIBTORCH_CUDA off CACHE BOOL "With LibTorch + CUDA? [on/off]")
set(INFERENCE_HELPER_ENABLE_TENSORFLOW off CACHE BOOL "With TensorFlow? [on/off]")
set(INFERENCE_HELPER_ENABLE_TENSORFLOW_GPU off CACHE BOOL "With TensorFlow + GPU? [on/off]")
set(INFERENCE_HELPER_ENABLE_SAMPLE off CACHE BOOL "With Sample? [on/off]")

# Create library
set(SRC inference_helper.h inference_helper.cpp inference_helper_log.h)

if(INFERENCE_HELPER_ENABLE_OPENCV)
    set(SRC ${SRC} inference_helper_opencv.h inference_helper_opencv.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_TFLITE OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_XNNPACK OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_GPU OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_QNN OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_EDGETPU OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_NNAPI)
    set(SRC ${SRC} inference_helper_tensorflow_lite.h inference_helper_tensorflow_lite.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_TENSORRT)
    set(SRC ${SRC} inference_helper_tensorrt.h inference_helper_tensorrt.cpp)
    set(SRC ${SRC} tensorrt/logger.cpp tensorrt/BatchStream.h tensorrt/common.h tensorrt/EntropyCalibrator.h tensorrt/logger.h tensorrt/logging.h)
endif()

if(INFERENCE_HELPER_ENABLE_NCNN)
    set(SRC ${SRC} inference_helper_ncnn.h inference_helper_ncnn.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_MNN)
    set(SRC ${SRC} inference_helper_mnn.h inference_helper_mnn.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_SNPE)
    set(SRC ${SRC} inference_helper_snpe.h inference_helper_snpe.cpp)
    set(SRC ${SRC} snpe/CreateUserBuffer.cpp snpe/CreateUserBuffer.hpp snpe/Util.cpp snpe/Util.hpp snpe/udlExample.cpp snpe/udlExample.hpp)
endif()

if(INFERENCE_HELPER_ENABLE_ARMNN)
    set(SRC ${SRC} inference_helper_armnn.h inference_helper_armnn.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_NNABLA OR INFERENCE_HELPER_ENABLE_NNABLA_CUDA)
    set(SRC ${SRC} inference_helper_nnabla.h inference_helper_nnabla.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_ONNX_RUNTIME OR INFERENCE_HELPER_ENABLE_ONNX_RUNTIME_CUDA)
    set(SRC ${SRC} inference_helper_onnx_runtime.h inference_helper_onnx_runtime.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_LIBTORCH OR INFERENCE_HELPER_ENABLE_LIBTORCH_CUDA)
    set(SRC ${SRC} inference_helper_libtorch.h inference_helper_libtorch.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_TENSORFLOW OR INFERENCE_HELPER_ENABLE_TENSORFLOW_GPU)
    set(SRC ${SRC} inference_helper_tensorflow.h inference_helper_tensorflow.cpp)
endif()

if(INFERENCE_HELPER_ENABLE_SAMPLE)
    set(SRC ${SRC} inference_helper_sample.h inference_helper_sample.cpp)
endif()

add_library(${LibraryName} ${SRC})

# For TensorInfo (Pre process calculation)
if(INFERENCE_HELPER_ENABLE_PRE_PROCESS_BY_OPENCV)
    find_package(OpenCV REQUIRED)
    target_include_directories(${LibraryName} PUBLIC ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(${LibraryName} PRIVATE ${OpenCV_LIBS})
    add_definitions(-DINFERENCE_HELPER_ENABLE_PRE_PROCESS_BY_OPENCV)
endif()

# For OpenCV
if(INFERENCE_HELPER_ENABLE_OPENCV)
    find_package(OpenCV REQUIRED)
    target_include_directories(${LibraryName} PUBLIC ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(${LibraryName} PRIVATE ${OpenCV_LIBS})
    add_definitions(-DINFERENCE_HELPER_ENABLE_OPENCV)
endif()

# For Tensorflow Lite
if(INFERENCE_HELPER_ENABLE_TFLITE OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_XNNPACK OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_GPU OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_QNN OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_EDGETPU OR INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_NNAPI)
    include(${THIRD_PARTY_DIR}/cmakes/tflite.cmake)
    target_include_directories(${LibraryName} PUBLIC ${TFLITE_INC})
    target_link_libraries(${LibraryName} PRIVATE ${TFLITE_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE)
endif()

# For Tensorflow Lite Delegate(XNNPACK)
if(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_XNNPACK)
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_XNNPACK)
endif()

# For Tensorflow Lite Delegate(GPU)
if(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_GPU)
    find_package(OpenCL)
    if(OpenCL_Found)
        target_include_directories(${LibraryName} PUBLIC ${OpenCL_INCLUDE_DIRS})
        target_link_libraries(${LibraryName} PRIVATE ${OpenCL_LIBRARIES})
    endif()
    include(${THIRD_PARTY_DIR}/cmakes/tflite_gpu.cmake)
    target_include_directories(${LibraryName} PUBLIC ${TFLITE_GPU_INC})
    target_link_libraries(${LibraryName} PRIVATE ${TFLITE_GPU_LIB} EGL GLESv2)
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_GPU)
endif()

# For Tensorflow Lite Delegate(QNN)
if(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_QNN)
    set(QNN_SDK "${THIRD_PARTY_DIR}/qairt/2.31.0.250130" CACHE PATH "Path to QNN SDK" FORCE)

    # Add preprocessor definition for QNN
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_QNN)

    # Add QNN include directory
    target_include_directories(${LibraryName} PUBLIC ${QNN_SDK}/include)

    message(STATUS "Added QNN include directory: ${QNN_SDK}/include")

    # Link required QNN libraries
    target_link_libraries(${LibraryName} PRIVATE
            ${QNN_SDK}/lib/aarch64-android/libQnnTFLiteDelegate.so
            ${QNN_SDK}/lib/aarch64-android/libQnnGpu.so
            ${QNN_SDK}/lib/aarch64-android/libQnnHtp.so
            ${QNN_SDK}/lib/aarch64-android/libQnnHtpPrepare.so
    )
endif()

# For Tensorflow Lite Delegate(Edge TPU)
if(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_EDGETPU)
    include(${THIRD_PARTY_DIR}/cmakes/tflite_edgetpu.cmake)
    target_include_directories(${LibraryName} PUBLIC ${TFLITE_EDGETPU_INC})
    target_link_libraries(${LibraryName} PRIVATE ${TFLITE_EDGETPU_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_EDGETPU)
endif()

# For Tensorflow Lite Delegate(NNAPI)
if(INFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_NNAPI)
    add_definitions(-DINFERENCE_HELPER_ENABLE_TFLITE_DELEGATE_NNAPI)
endif()


# For TensorRT
if(INFERENCE_HELPER_ENABLE_TENSORRT)
    find_package(CUDA)
    if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0") 
        if(MSVC_VERSION)
            # note: the following lines for my environment (Windows 10/11. cuDNN is copied into CUDA install path)
            # Copy TensorRT into CUDA install path
            # or, Set environment variable(TensorRT_ROOT = C:\Program Files\NVIDIA GPU Computing Toolkit\TensorRT\TensorRT-8.2.0.6), and add %TensorRT_ROOT%\lib to path
            target_link_directories(${LibraryName} PUBLIC ${CUDA_TOOLKIT_ROOT_DIR}/bin)
            target_link_directories(${LibraryName} PUBLIC ${CUDA_TOOLKIT_ROOT_DIR}/lib/x64)
        else()
            target_link_directories(${LibraryName} PUBLIC /usr/local/cuda/lib64)
        endif()
    endif()
    if(CUDA_FOUND)
        if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.13.0") 
            if(NOT $ENV{TensorRT_ROOT} STREQUAL "")
                target_link_directories(${LibraryName} PUBLIC $ENV{TensorRT_ROOT}/lib)
            endif()
        endif()
        target_link_libraries(${LibraryName} PRIVATE
            ${CUDA_LIBRARIES}
            nvinfer
            nvonnxparser
            nvinfer_plugin
            cudnn
        )
        target_include_directories(${LibraryName} PUBLIC
            ${CUDA_INCLUDE_DIRS}
            tensorrt
        )
        if(NOT $ENV{TensorRT_ROOT} STREQUAL "")
            target_include_directories(${LibraryName} PUBLIC $ENV{TensorRT_ROOT}/include)
        endif()
        add_definitions(-DINFERENCE_HELPER_ENABLE_TENSORRT)
        message("CUDA_INCLUDE_DIRS: ${CUDA_INCLUDE_DIRS}")
    else()
        message(WARNING, "Cannot find CUDA")
    endif()
endif()

# For NCNN
if(INFERENCE_HELPER_ENABLE_NCNN)
    include(${THIRD_PARTY_DIR}/cmakes/ncnn.cmake)
    target_include_directories(${LibraryName} PUBLIC ${NCNN_INC})
    target_link_libraries(${LibraryName} PRIVATE ${NCNN_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_NCNN)
endif()

# For MNN
if(INFERENCE_HELPER_ENABLE_MNN)
    include(${THIRD_PARTY_DIR}/cmakes/mnn.cmake)
    target_include_directories(${LibraryName} PUBLIC ${MNN_INC})
    target_link_libraries(${LibraryName} PRIVATE ${MNN_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_MNN)
endif()

# For SNPE
if(INFERENCE_HELPER_ENABLE_SNPE)
    include(${THIRD_PARTY_DIR}/cmakes/snpe.cmake)
    target_include_directories(${LibraryName} PUBLIC ${SNPE_INC} ./snpe)
    target_link_libraries(${LibraryName} PRIVATE ${SNPE_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_SNPE)
endif()

# For ARMNN
if(INFERENCE_HELPER_ENABLE_ARMNN)
    include(${THIRD_PARTY_DIR}/cmakes/armnn.cmake)
    target_include_directories(${LibraryName} PUBLIC ${ARMNN_INC})
    target_link_libraries(${LibraryName} PRIVATE ${ARMNN_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_ARMNN)
endif()

# For NNABLA
if(INFERENCE_HELPER_ENABLE_NNABLA OR INFERENCE_HELPER_ENABLE_NNABLA_CUDA)
    include(${THIRD_PARTY_DIR}/cmakes/nnabla.cmake)
    target_include_directories(${LibraryName} PUBLIC ${NNABLA_INC})
    target_link_libraries(${LibraryName} PRIVATE ${NNABLA_LIB})
    if (INFERENCE_HELPER_ENABLE_NNABLA)
        add_definitions(-DINFERENCE_HELPER_ENABLE_NNABLA)
    endif()
    if (INFERENCE_HELPER_ENABLE_NNABLA_CUDA)
        find_package(CUDA)
        target_link_libraries(${LibraryName} PRIVATE ${CUDA_LIBRARIES})
        target_include_directories(${LibraryName} PUBLIC ${CUDA_INCLUDE_DIRS})
        add_definitions(-DINFERENCE_HELPER_ENABLE_NNABLA_CUDA)
    endif()
endif()

# For ONNX Runtime 
if(INFERENCE_HELPER_ENABLE_ONNX_RUNTIME OR INFERENCE_HELPER_ENABLE_ONNX_RUNTIME_CUDA)
    include(${THIRD_PARTY_DIR}/cmakes/onnx_runtime.cmake)
    target_include_directories(${LibraryName} PUBLIC ${ONNX_RUNTIME_INC})
    target_link_libraries(${LibraryName} PRIVATE ${ONNX_RUNTIME_LIB})
    if (INFERENCE_HELPER_ENABLE_ONNX_RUNTIME)
        add_definitions(-DINFERENCE_HELPER_ENABLE_ONNX_RUNTIME)
    endif()
    if (INFERENCE_HELPER_ENABLE_ONNX_RUNTIME_CUDA)
        # find_package(CUDA)
        # target_link_libraries(${LibraryName} PRIVATE ${CUDA_LIBRARIES})
        # target_include_directories(${LibraryName} PUBLIC ${CUDA_INCLUDE_DIRS})
        add_definitions(-DINFERENCE_HELPER_ENABLE_ONNX_RUNTIME_CUDA)
    endif()
endif()

# For LibTorch
if(INFERENCE_HELPER_ENABLE_LIBTORCH OR INFERENCE_HELPER_ENABLE_LIBTORCH_CUDA)
    include(${THIRD_PARTY_DIR}/cmakes/libtorch.cmake)
    target_include_directories(${LibraryName} PUBLIC ${LIBTORCH_INC})
    target_link_libraries(${LibraryName} PRIVATE  ${LIBTORCH_LIB})  # Use PRIVATE to avoid `Target "torch_cpu" not found.` error when cmake configure
    if (INFERENCE_HELPER_ENABLE_LIBTORCH)
        add_definitions(-DINFERENCE_HELPER_ENABLE_LIBTORCH)
    endif()
    if (INFERENCE_HELPER_ENABLE_LIBTORCH_CUDA)
        # find_package(CUDA)
        # target_link_libraries(${LibraryName} PRIVATE ${CUDA_LIBRARIES})
        # target_include_directories(${LibraryName} PUBLIC ${CUDA_INCLUDE_DIRS})
        add_definitions(-DINFERENCE_HELPER_ENABLE_LIBTORCH_CUDA)
    endif()
endif()

# For TensorFlow
if(INFERENCE_HELPER_ENABLE_TENSORFLOW OR INFERENCE_HELPER_ENABLE_TENSORFLOW_GPU)
    include(${THIRD_PARTY_DIR}/cmakes/tensorflow.cmake)
    target_include_directories(${LibraryName} PUBLIC ${TENSORFLOW_INC})
    target_link_libraries(${LibraryName} PRIVATE  ${TENSORFLOW_LIB})
    if (INFERENCE_HELPER_ENABLE_TENSORFLOW)
        add_definitions(-DINFERENCE_HELPER_ENABLE_TENSORFLOW)
    endif()
    if (INFERENCE_HELPER_ENABLE_TENSORFLOW_GPU)
        # find_package(CUDA)
        # target_link_libraries(${LibraryName} PRIVATE ${CUDA_LIBRARIES})
        # target_include_directories(${LibraryName} PUBLIC ${CUDA_INCLUDE_DIRS})
        add_definitions(-DINFERENCE_HELPER_ENABLE_TENSORFLOW_GPU)
    endif()
endif()

# For Sample (template code to implement a new framework)
if(INFERENCE_HELPER_ENABLE_SAMPLE)
    include(${THIRD_PARTY_DIR}/cmakes/sample.cmake)
    target_include_directories(${LibraryName} PUBLIC ${SAMPLE_INC})
    target_link_libraries(${LibraryName} PRIVATE ${SAMPLE_LIB})
    add_definitions(-DINFERENCE_HELPER_ENABLE_SAMPLE)
endif()
