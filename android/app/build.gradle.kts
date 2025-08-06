plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.onmitrix"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.onmitrix"
        minSdk = 21
        targetSdk = 34
        versionCode = 25
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

androidComponents {
    finalizeDsl {
        it.lint.apply {
            checkDependencies = false
            abortOnError = false
            disable.add("InvalidPackage")
        }
    }
}
