plugins {
    id("java")
    alias(libs.plugins.lombok)
    war
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(libs.spring.webmvc)
    implementation(libs.spring.context.supprt)
    implementation(libs.spring.data.jpa)
    implementation(libs.hibernate.core)

    implementation(libs.hibernate.validator)

    implementation(libs.jackson.datatype.jsr310)
    implementation(libs.jackson.dataformat.xml)

    implementation(libs.hikariCP)

    implementation(libs.logback.classic)

    runtimeOnly(libs.mssql.jdbc)

    compileOnly(libs.jakarta.servlet)

    annotationProcessor(libs.hibernate.jpamodelgen)


    testImplementation(platform("org.junit:junit-bom:5.9.1"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testImplementation(libs.spring.test)
}

tasks.test {
    useJUnitPlatform()
}
