#!/bin/bash

# Script test cấu hình preset mà không build thực tế
# Sử dụng: ./test-config.sh [preset_name]

# Thiết lập cơ bản
export BASEDIR="$(pwd)"

# Các options cơ bản
BASIC_OPTIONS="--enable-android-zlib --enable-android-media-codec"

# Định nghĩa các preset libraries theo mobile-ffmpeg
GPL_LIBS="--enable-libvidstab --enable-x264 --enable-x265 --enable-xvidcore"
HTTPS_LIBS="--enable-gmp --enable-gnutls"
AUDIO_LIBS="--enable-lame --enable-libilbc --enable-libvorbis --enable-opencore-amr --enable-opus --enable-shine --enable-soxr --enable-speex --enable-twolame --enable-vo-amrwbenc"
AUDIO_LIBS_SAFE="--enable-lame --enable-libvorbis --enable-opencore-amr --enable-opus --enable-shine --enable-speex --enable-twolame --enable-vo-amrwbenc"
VIDEO_LIBS="--enable-fontconfig --enable-freetype --enable-fribidi --enable-kvazaar --enable-libaom --enable-libass --enable-libiconv --enable-libtheora --enable-libvpx --enable-snappy --enable-libwebp"
VIDEO_LIBS_SAFE="--enable-fontconfig --enable-freetype --enable-fribidi --enable-kvazaar --enable-libass --enable-libiconv --enable-libtheora --enable-libvpx --enable-libwebp"
FULL_LIBS="${HTTPS_LIBS} ${AUDIO_LIBS} ${VIDEO_LIBS} --enable-libxml2"
CMAKE_SAFE_LIBS="${HTTPS_LIBS} ${AUDIO_LIBS_SAFE} ${VIDEO_LIBS_SAFE} --enable-libxml2"

show_help() {
    echo "Test cấu hình preset build:"
    echo "Cách sử dụng: $0 [preset_name]"
    echo ""
    echo "Các preset có sẵn:"
    echo "  min, https, audio, video, full, min-gpl, https-gpl, full-gpl, cmake-safe"
}

test_preset() {
    local preset=$1
    local build_options="${BASIC_OPTIONS}"
    local gpl_flag=""
    
    echo "🧪 Test cấu hình preset: ${preset}"
    echo ""
    
    case ${preset} in
        "min")
            echo "📦 Preset MIN: Chỉ basic libraries"
            ;;
        "https")
            echo "📦 Preset HTTPS: Basic + gmp + gnutls"
            build_options="${build_options} ${HTTPS_LIBS}"
            ;;
        "audio")
            echo "📦 Preset AUDIO: Basic + audio libraries (không bao gồm wavpack)"
            build_options="${build_options} ${AUDIO_LIBS}"
            ;;
        "video") 
            echo "📦 Preset VIDEO: Basic + video libraries"
            build_options="${build_options} ${VIDEO_LIBS}"
            ;;
        "full")
            echo "📦 Preset FULL: Basic + tất cả non-GPL libraries"
            build_options="${build_options} ${FULL_LIBS}"
            ;;
        "min-gpl")
            echo "📦 Preset MIN-GPL: Basic + GPL libraries"
            build_options="${build_options} ${GPL_LIBS}"
            gpl_flag="--enable-gpl"
            ;;
        "https-gpl")
            echo "📦 Preset HTTPS-GPL: HTTPS + GPL libraries"
            build_options="${build_options} ${HTTPS_LIBS} ${GPL_LIBS}"
            gpl_flag="--enable-gpl"
            ;;
        "full-gpl")
            echo "📦 Preset FULL-GPL: FULL + GPL libraries"
            build_options="${build_options} ${FULL_LIBS} ${GPL_LIBS}"
            gpl_flag="--enable-gpl"
            ;;
        "cmake-safe")
            echo "📦 Preset CMAKE-SAFE: Basic + safe libraries"
            build_options="${build_options} ${CMAKE_SAFE_LIBS}"
            ;;
        *)
            echo "❌ Preset không hợp lệ: ${preset}"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    echo "🔧 Command sẽ chạy:"
    if [[ -n ${gpl_flag} ]]; then
        echo "   ./android.sh ${build_options} ${gpl_flag}"
    else
        echo "   ./android.sh ${build_options}"
    fi
    
    echo ""
    echo "📊 Số lượng libraries:"
    local lib_count=$(echo ${build_options} | grep -o -- '--enable-[a-zA-Z0-9-]*' | wc -l)
    echo "   Total: ${lib_count} libraries"
    
    echo ""
    echo "📋 Chi tiết libraries:"
    echo ${build_options} | grep -o -- '--enable-[a-zA-Z0-9-]*' | sort | sed 's/--enable-/   - /'
    
    if [[ -n ${gpl_flag} ]]; then
        echo ""
        echo "⚖️  GPL libraries:"
        echo ${GPL_LIBS} | grep -o -- '--enable-[a-zA-Z0-9-]*' | sed 's/--enable-/   - /'
    fi
    
    echo ""
    echo "✅ Test thành công! Cấu hình preset '${preset}' hợp lệ."
    echo ""
    echo "💡 Để build thực tế:"
    echo "   1. Set biến môi trường: export ANDROID_SDK_ROOT=/path/to/sdk"
    echo "   2. Set biến môi trường: export ANDROID_NDK_ROOT=/path/to/ndk"
    echo "   3. Chạy: ./build-presets.sh ${preset}"
}

# Kiểm tra tham số đầu vào
if [[ $# -eq 0 ]]; then
    echo "❌ Thiếu tham số preset"
    show_help
    exit 1
fi

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Test preset
test_preset "$1" 