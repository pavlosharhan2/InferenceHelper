#!/usr/bin/env bash

IGNORE_GPU=${1:-0}

move_dir_to_shell_file() {
    dir_shell_file=`dirname "$0"`
    cd "${dir_shell_file}"
}

download_and_extract_ncnn() {
    local url_base="https://github.com/Tencent/ncnn/releases/download/"
    local tag="20211208"
    local prefix="ncnn-20211208-"
    local name=$1
    local url="${url_base}${tag}/${prefix}${name}.zip"
    echo "Downloading ${url}"
    curl -Lo temp.zip  "${url}"
    unzip -o temp.zip
    rm -rf temp.zip
    rm -rf "${name}"
    mv "${prefix}${name}" "${name}"
}

download_and_extract() {
    local url=$1
    echo "Downloading ${url}"
    local ext=${url##*.}
    if echo "${ext}" | grep -q zip; then
        curl -Lo temp.zip "${url}"
        unzip -o temp.zip
        rm -f temp.zip
    else
        curl -Lo temp.tgz "${url}"
        tar xzvf temp.tgz
        rm -f temp.tgz
    fi
}

download_and_extract_onnxruntime() {
    local url_base="https://github.com/microsoft/onnxruntime/releases/download/"
    local tag="v1.10.0"
    local prefix="onnxruntime-"
    local suffix="-1.10.0"
    local name=$1
    local ext=$2
    local url="${url_base}${tag}/${prefix}${name}${suffix}.${ext}"
    echo "Downloading ${url}"
    if echo "${ext}" | grep -q zip; then
        curl -Lo temp.zip "${url}"
        unzip -o temp.zip
        rm -f temp.zip
    else
        curl -Lo temp.tgz "${url}"
        tar xzvf temp.tgz
        rm -f temp.tgz
    fi
    rm -rf "${name}"
    mv "${prefix}${name}${suffix}" "${name}"
}

download_and_extract_onnxruntime_andriod() {
    # https://search.maven.org/artifact/com.microsoft.onnxruntime/onnxruntime-mobile/1.10.0/aar
    local url="https://search.maven.org/remotecontent?filepath=com/microsoft/onnxruntime/onnxruntime-mobile/1.10.0/onnxruntime-mobile-1.10.0.aar"
    echo "Downloading ${url}"
    mkdir -p android && cd android
    curl -Lo temp.zip "${url}"
    unzip -o temp.zip
    rm -f temp.zip
    cd ..
}

download_and_extract_libtorch_andriod() {
    local url="https://repo1.maven.org/maven2/org/pytorch/pytorch_android_torchvision/1.12/pytorch_android_torchvision-1.12.aar"
    echo "Downloading ${url}"
    mkdir -p android && cd android
    curl -Lo temp.zip "${url}"
    unzip -o temp.zip
    rm -f temp.zip
    cd ..
}

# This is the new function that always places tflite_prebuilt.zip contents into tflite_prebuilt folder
download_and_extract_tflite_prebuilt() {
    local url=$1
    echo "Downloading ${url}"
    mkdir -p tflite_prebuilt
    curl -Lo temp.zip "${url}"
    unzip -o temp.zip -d tflite_prebuilt
    rm -f temp.zip
}

# Go to script directory
move_dir_to_shell_file

# Download some prerequisites
download_and_extract "https://softwarecenter.qualcomm.com/api/download/software/qualcomm_neural_processing_sdk/v2.31.0.250130.zip"
download_and_extract "https://github.com/opencv/opencv/releases/download/4.10.0/opencv-4.10.0-android-sdk.zip"
mv OpenCV-android-sdk ../../../MyhawkSimple
# Custom build gradle so OpenCV can be used in both Java and C++
cp -f ../opencv_android_gradle/build.gradle ../../../MyhawkSimple/OpenCV-android-sdk/sdk/

# Initialize submodules
git submodule update --init --recommend-shallow --depth 1

# Download TFLite prebuilt and ensure it lands in 'tflite_prebuilt' folder
download_and_extract_tflite_prebuilt "https://github.com/pavloshargan/InferenceHelper/releases/download/v1.0/tflite_prebuilt.zip"

# Download and extract ncnn prebuilt libraries
mkdir -p ncnn_prebuilt && cd ncnn_prebuilt
download_and_extract_ncnn "android-vulkan"
download_and_extract_ncnn "android"
download_and_extract_ncnn "ubuntu-2004-shared"
download_and_extract_ncnn "ubuntu-2004"
download_and_extract_ncnn "windows-vs2019-shared"
download_and_extract_ncnn "windows-vs2019"
cd ..

# Download NNabla prebuilt libraries
mkdir -p nnabla_prebuilt/windows-vs2019 && mkdir -p nnabla_prebuilt/aarch64 && cd nnabla_prebuilt
curl -L https://nnabla.org/cpplib/1.25.0/nnabla-cpplib-1.25.0-win64.zip -o temp.zip
unzip -o temp.zip
rm -f temp.zip
mv nnabla-cpplib-1.25.0-win64/* windows-vs2019/.

if [ "${IGNORE_GPU}" -eq 0 ]; then
    curl -L https://nnabla.org/cpplib/1.25.0/nnabla-cpplib-cuda_110_8-1.25.0-win64.zip -o temp.zip
    unzip -o temp.zip
    rm -f temp.zip
    cp -r nnabla-cpplib-cuda_110_8-1.25.0-win64/* windows-vs2019/.
fi

curl -L https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-v3.5.2-win64.zip -o temp.zip
unzip -o temp.zip
mv libarchive/bin/archive.dll windows-vs2019/bin/.
rm -f temp.zip

curl -L https://nnabla.org/cpplib/1.25.0/nnabla-cpplib-1.25.0-Linux_aarch64.zip -o temp.zip
unzip -o temp.zip
rm -f temp.zip
mv nnabla-cpplib-1.25.0-Linux_aarch64/* aarch64/.
cd ..

# Download ONNX Runtime prebuilt libraries
mkdir -p onnxruntime_prebuilt && cd onnxruntime_prebuilt
download_and_extract_onnxruntime "win-x64" "zip"
download_and_extract_onnxruntime "linux-x64" "tgz"
download_and_extract_onnxruntime "linux-aarch64" "tgz"
download_and_extract_onnxruntime_andriod
if [ "${IGNORE_GPU}" -eq 0 ]; then
    download_and_extract_onnxruntime "win-x64-gpu" "zip"
    download_and_extract_onnxruntime "linux-x64-gpu" "tgz"
fi
cd ..

# Download LibTorch prebuilt libraries
mkdir -p libtorch_prebuilt && cd libtorch_prebuilt
download_and_extract "https://download.pytorch.org/libtorch/cpu/libtorch-win-shared-with-deps-1.11.0%2Bcpu.zip"
mv libtorch win-x64
download_and_extract "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcpu.zip"
mv libtorch linux-x64
download_and_extract_libtorch_andriod
if [ "${IGNORE_GPU}" -eq 0 ]; then
    download_and_extract "https://download.pytorch.org/libtorch/cu113/libtorch-win-shared-with-deps-1.11.0%2Bcu113.zip"
    mv libtorch win-x64-gpu
    download_and_extract "https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcu113.zip"
    mv libtorch linux-x64-gpu
fi
cd ..

# Download TensorFlow prebuilt libraries
mkdir -p tensorflow_prebuilt && cd tensorflow_prebuilt

mkdir -p win-x64 && cd win-x64
download_and_extract "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-windows-x86_64-2.7.0.zip"
cd ..

mkdir -p linux-x64 && cd linux-x64
download_and_extract "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.7.0.tar.gz"
if [ "${IGNORE_GPU}" -eq 0 ]; then
    cd ..
    mkdir -p win-x64-gpu && cd win-x64-gpu
    download_and_extract "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-windows-x86_64-2.7.0.zip"
    cd ..
    mkdir -p linux-x64-gpu && cd linux-x64-gpu
    download_and_extract "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-2.7.0.tar.gz"
fi

cd ..
