#ifdef Q_OS_ANDROID
#include <QtCore/qnativeinterface.h>
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "audiolevel.h" // Подключаем наш новый файл

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    
    // Регистрируем тип
    qmlRegisterType<AudioLevel>("CyberMedia", 1, 0, "AudioLevel");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/kursach/Main.qml"));
    engine.load(url);
    
    return app.exec();
}
#endif
