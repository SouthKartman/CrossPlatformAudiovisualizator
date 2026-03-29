#ifndef AUDIOLEVEL_H
#define AUDIOLEVEL_H

#include <QObject>
#include <QAudioSource>
#include <QAudioFormat>
#include <QIODevice>

class AudioLevel : public QObject {
    Q_OBJECT
    Q_PROPERTY(double level READ level NOTIFY levelChanged)
public:
    AudioLevel(QObject *parent = nullptr) : QObject(parent) {
        QAudioFormat format;
        format.setSampleRate(44100);
        format.setChannelCount(1);
        format.setSampleFormat(QAudioFormat::Int16);

        m_audioSource = new QAudioSource(format, this);
        m_ioDevice = m_audioSource->start();

        connect(m_ioDevice, &QIODevice::readyRead, [this]() {
            const QByteArray data = m_ioDevice->readAll();
            if (data.isEmpty()) return;
            qint16 maxVal = 0;
            const qint16* samples = reinterpret_cast<const qint16*>(data.data());
            for (int i = 0; i < data.size() / 2; ++i) {
                if (qAbs(samples[i]) > maxVal) maxVal = qAbs(samples[i]);
            }
            m_level = maxVal / 32768.0;
            emit levelChanged();
        });
    }
    double level() const { return m_level; }
signals:
    void levelChanged();
private:
    QAudioSource* m_audioSource = nullptr;
    QIODevice* m_ioDevice = nullptr;
    double m_level = 0;
};

#endif
