group = "com.jk.ekyc"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.4.0"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// The SDK ships as local .aar files. flatDir must be visible to the host app too,
// because the app resolves this library's transitive dependencies.
val sdkLibsDir = file("libs")
rootProject.allprojects {
    repositories {
        flatDir { dirs(sdkLibsDir) }
        maven { url = uri("https://jitpack.io") }
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "com.jk.ekyc"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
        consumerProguardFiles("consumer-rules.pro")
    }

    // The VNPT SDK's compiled fragments reference the ViewBinding runtime
    // (androidx.viewbinding.ViewBindings) directly. Without this, any host app
    // crashes with NoClassDefFoundError as soon as the SDK's camera UI opens.
    buildFeatures {
        viewBinding = true
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation(mapOf("name" to "ekyc_sdk-release-v3.7.4", "ext" to "aar"))
    implementation(mapOf("name" to "scanqr_ic_sdk-release-v1.0.6", "ext" to "aar"))
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.core:core:1.9.0")
    implementation("androidx.constraintlayout:constraintlayout:2.0.4")
    implementation("com.google.code.gson:gson:2.8.6")
    implementation("com.squareup.okhttp3:okhttp:4.9.0")
    implementation("org.bouncycastle:bcpkix-jdk15on:1.67")
    implementation("com.airbnb.android:lottie:5.0.1")
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
}
