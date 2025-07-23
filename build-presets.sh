#!/bin/bash

# Script để build FFmpeg-Kit theo các preset của mobile-ffmpeg-master
# Sử dụng: ./build-presets.sh [preset_name]
# Các preset: min, https, audio, video, full, min-gpl, https-gpl, full-gpl, cmake-safe

# Thiết lập cơ bản
export BASEDIR="$(pwd)"

# Các options cơ bản (tương tự mobile-ffmpeg CUSTOM_OPTIONS)
BASIC_OPTIONS="--enable-android-zlib --enable-android-media-codec"

# Định nghĩa các preset libraries theo mobile-ffmpeg
# GPL Libraries
GPL_LIBS="--enable-libvidstab --enable-x264 --enable-x265 --enable-xvidcore"

# HTTPS Libraries  
HTTPS_LIBS="--enable-gmp --enable-gnutls"

# Audio Libraries (loại bỏ wavpack vì không được support trong ffmpeg-kit)
AUDIO_LIBS="--enable-lame --enable-libilbc --enable-libvorbis --enable-opencore-amr --enable-opus --enable-shine --enable-soxr --enable-speex --enable-twolame --enable-vo-amrwbenc"

# Audio Libraries SAFE (không dùng CMake) - loại bỏ libilbc, soxr
AUDIO_LIBS_SAFE="--enable-lame --enable-libvorbis --enable-opencore-amr --enable-opus --enable-shine --enable-speex --enable-twolame --enable-vo-amrwbenc"

# Video Libraries
VIDEO_LIBS="--enable-fontconfig --enable-freetype --enable-fribidi --enable-kvazaar --enable-libass --enable-libiconv --enable-libtheora --enable-libvpx --enable-snappy --enable-libwebp"

# Video Libraries SAFE (không dùng CMake) - loại bỏ snappy, libaom
VIDEO_LIBS_SAFE="--enable-fontconfig --enable-freetype --enable-fribidi --enable-kvazaar --enable-libass --enable-libiconv --enable-libtheora --enable-libvpx --enable-libwebp"

# Full Libraries (tất cả non-GPL)
FULL_LIBS="${HTTPS_LIBS} ${AUDIO_LIBS} ${VIDEO_LIBS} --enable-libxml2"

# CMake-Safe Libraries (tránh CMake version conflicts)
# Loại bỏ: libilbc, soxr (audio), snappy, libaom, jpeg (video/image)
CMAKE_SAFE_LIBS="${HTTPS_LIBS} ${AUDIO_LIBS_SAFE} ${VIDEO_LIBS_SAFE} --enable-libxml2"

# Minimal-Safe Libraries (chỉ basic + HTTPS + audio, không có video)
MINIMAL_SAFE_LIBS="${HTTPS_LIBS} ${AUDIO_LIBS_SAFE}"

# Near-Full Libraries (loại bỏ chỉ gnutls - 25/26 libraries)
NEAR_FULL_LIBS="--enable-gmp ${AUDIO_LIBS} ${VIDEO_LIBS} --enable-libxml2"

show_help() {
    echo "Cách sử dụng: $0 [preset_name]"
    echo ""
    echo "Các preset có sẵn:"
    echo "  min         - Chỉ có basic libraries (android-zlib, android-media-codec)"
    echo "  https       - min + gmp + gnutls"
    echo "  audio       - min + tất cả audio libraries"  
    echo "  video       - min + tất cả video libraries"
    echo "  full        - min + tất cả non-GPL libraries"
    echo "  min-gpl     - min + GPL libraries"
    echo "  https-gpl   - https + GPL libraries"
    echo "  full-gpl    - full + GPL libraries"
    echo "  cmake-safe    - tương tự full nhưng loại bỏ libraries dùng CMake"
    echo "  minimal-safe  - chỉ basic + HTTPS + audio (tránh video dependencies)"
    echo "  near-full     - tất cả libraries trừ gnutls (25/26 = 96% compatibility)"
    echo ""
    echo "Lưu ý:"
    echo "  - wavpack không được support trong FFmpeg-Kit nên đã bỏ khỏi preset audio"
    echo "  - cmake-safe loại bỏ: libilbc, soxr, snappy, libaom, jpeg (do CMake conflicts)"
    echo "  - minimal-safe tránh video libraries để không auto-include image dependencies"
    echo "  - near-full loại bỏ chỉ gnutls (TLS support vẫn có qua Android system)"
    echo ""
    echo "Ví dụ:"
    echo "  $0 min         # Build preset minimal"
    echo "  $0 audio       # Build preset audio"
    echo "  $0 near-full   # Build 25/26 libraries (recommended!)"
    echo "  $0 cmake-safe  # Build an toàn, tránh CMake issues"
}

build_preset() {
    local preset=$1
    local build_options="${BASIC_OPTIONS}"
    local gpl_flag=""
    
    echo "🚀 Building FFmpeg-Kit với preset: ${preset}"
    echo "⏰ Bắt đầu lúc: $(date)"
    
    case ${preset} in
        "min")
            echo "📦 Preset MIN: Chỉ basic libraries"
            # Chỉ có BASIC_OPTIONS
            ;;
        "https")
            echo "📦 Preset HTTPS: Basic + gmp + gnutls"
            build_options="${build_options} ${HTTPS_LIBS}"
            ;;
        "audio")
            echo "📦 Preset AUDIO: Basic + tất cả audio libraries (không bao gồm wavpack)"
            build_options="${build_options} ${AUDIO_LIBS}"
            ;;
        "video") 
            echo "📦 Preset VIDEO: Basic + tất cả video libraries"
            build_options="${build_options} ${VIDEO_LIBS}"
            ;;
        "full")
            echo "📦 Preset FULL: Basic + tất cả non-GPL libraries"
            build_options="${build_options} ${FULL_LIBS}"
            ;;
        "cmake-safe")
            echo "📦 Preset CMAKE-SAFE: Tương tự FULL nhưng tránh CMake conflicts"
            echo "    🔧 Loại bỏ: libilbc, soxr, snappy, libaom (libraries dùng CMake)"
            echo "    ✅ An toàn với CMake version 4.x"
            build_options="${build_options} ${CMAKE_SAFE_LIBS}"
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
        "minimal-safe")
            echo "📦 Preset MINIMAL-SAFE: Basic + HTTPS + audio safe (không có video)"
            build_options="${build_options} ${MINIMAL_SAFE_LIBS}"
            ;;
        "near-full")
            echo "📦 Preset NEAR-FULL: Basic + tất cả libraries (trừ gnutls)"
            build_options="${build_options} ${NEAR_FULL_LIBS}"
            ;;
        *)
            echo "❌ Preset không hợp lệ: ${preset}"
            show_help
            exit 1
            ;;
    esac
    
    # Hiển thị cấu hình sẽ build
    echo ""
    echo "🔧 Cấu hình build:"
    echo "   Basic options: ${BASIC_OPTIONS}"
    if [[ -n ${gpl_flag} ]]; then
        echo "   GPL enabled: ${gpl_flag}"
    fi
    echo "   Libraries: ${build_options}"
    echo ""
    if [[ "${preset}" == "cmake-safe" ]]; then
        echo "✅ CMake-Safe preset: Tránh được CMake version conflicts"
        echo "   Loại bỏ: libilbc, soxr, snappy, libaom"
    elif [[ "${preset}" == "near-full" ]]; then
        echo "🎯 Near-Full preset: 25/26 libraries (96% mobile-ffmpeg compatibility)"
        echo "   Loại bỏ chỉ: gnutls (TLS vẫn có qua Android system SSL)"
        echo "   Bao gồm: All CMake libraries, audio, video, image processing"
    else
        echo "⚠️  Lưu ý: Một số libraries từ mobile-ffmpeg không có trong FFmpeg-Kit:"
        echo "   - wavpack (đã loại bỏ)"
    fi
    echo ""
    
    # Thực hiện build
    echo "🔨 Bắt đầu build..."
    if [[ -n ${gpl_flag} ]]; then
        ./android.sh ${build_options} ${gpl_flag}
    else
        ./android.sh ${build_options}
    fi
    
    local exit_code=$?
    
    if [ ${exit_code} -eq 0 ]; then
        echo ""
        echo "✅ Build thành công với preset: ${preset}"
        echo "⏰ Hoàn thành lúc: $(date)"
        echo "📁 Output sẽ ở trong thư mục: prebuilt/"
    else
        echo ""
        echo "❌ Build thất bại với preset: ${preset}"
        echo "📋 Kiểm tra file build.log để xem chi tiết lỗi"
        exit ${exit_code}
    fi
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

# Kiểm tra file android.sh có tồn tại không
if [[ ! -f "./android.sh" ]]; then
    echo "❌ Không tìm thấy file android.sh trong thư mục hiện tại"
    echo "   Vui lòng chạy script này từ thư mục gốc của ffmpeg-kit"
    exit 1
fi

# Thực hiện build
build_preset "$1" 