cmake_minimum_required(VERSION 3.16)
project(kursach VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON) # Перенеси сюда
set(CMAKE_AUTOUIC ON) # Полезно для будущего
set(CMAKE_AUTORCC ON) # Для ресурсов

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Multimedia)
qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(appkursach 
    main.cpp 
    audiolevel.h 
    audiolevel.cpp # <--- Добавь его сюда
)

qt_add_qml_module(appkursach
    URI kursach
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_libraries(appkursach PRIVATE Qt6::Quick Qt6::Multimedia)



if(ANDROID)
    # Фиксируем версию SDK, чтобы Gradle не брал экспериментальный API 36
    set(QT_ANDROID_API_VERSION 34)
    set(QT_ANDROID_COMPILE_SDK_VERSION 34)
    set(QT_ANDROID_TARGET_SDK_VERSION 34)
    
    # Путь к манифесту (убедитесь, что папка android создана)
    set_property(TARGET appkursach PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
endif()

# Для Windows: иконка и тип приложения
if(WIN32)
    set_target_properties(appkursach PROPERTIES WIN32_EXECUTABLE TRUE)
endif()