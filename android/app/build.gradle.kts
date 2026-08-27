import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Production signing credentials are read from android/key.properties
// (never committed) or from CI environment variables. See RELEASE_SIGNING.md.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) {
        load(FileInputStream(file))
    }
}

fun signingProperty(name: String): String? =
    keystoreProperties.getProperty(name)
        ?: System.getenv("MIDRAR_SIGNING_${name.uppercase().replace('.', '_')}")

android {
    namespace = "com.midrar.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            val storeFilePath = signingProperty("storeFile")
            val storePass = signingProperty("storePassword")
            val keyAliasName = signingProperty("keyAlias")
            val keyPass = signingProperty("keyPassword")
            if (storeFilePath != null && storePass != null && keyAliasName != null && keyPass != null) {
                storeFile = file(storeFilePath)
                this.storePassword = storePass
                this.keyAlias = keyAliasName
                this.keyPassword = keyPass
            }
            // When credentials are absent the config stays incomplete and the
            // release build fails fast with a clear error. Debug signing is
            // never used as a silent fallback for releases.
        }
    }

    defaultConfig {
        applicationId = "com.midrar.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Fails with "Keystore file not set for signing config release"
            // unless proper credentials are provided via key.properties or env.
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

