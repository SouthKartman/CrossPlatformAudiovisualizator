#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "audiolevel.h"

// Если нужны специфичные инклуды для Android, пишем их тут
#ifdef Q_OS_ANDROID
#include <QtCore/qnativeinterface.h>
#endif

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    
    // Этот код общий для всех платформ
    qmlRegisterType<AudioLevel>("CyberMedia", 1, 0, "AudioLevel");
    
    QQmlApplicationEngine engine;

    // for only qt 6.4
    const QUrl url(QStringLiteral("qrc:/kursach/Main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);

    engine.load(url);
    // try 5
    return app.exec();
}
