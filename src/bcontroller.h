#ifndef BCONTROLLER_H
#define BCONTROLLER_H


#include <QQuickView>
#include <QQuickWidget>
#include <QSerialPortInfo>
#include <serial/serialsenderreceiver.h>
#include <src/serialcommunication/serialcommunication.h>


class BController : public QQuickView
{
    Q_OBJECT
    Q_PROPERTY(QString serialMessage READ serialMessage WRITE setSerialMessage NOTIFY serialMessageChanged)
    Q_PROPERTY(bool connectionStatus READ connectionStatus WRITE setConnectionStatus NOTIFY connectionStatusChanged)
    Q_PROPERTY(float xAxisValue READ xAxisValue WRITE setXAxisValue NOTIFY xAxisValueChanged)
    Q_PROPERTY(float yAxisValue READ yAxisValue WRITE setYAxisValue NOTIFY yAxisValueChanged)

public:
    explicit BController(QWindow *parent = nullptr);

    virtual ~BController();

    QString serialMessage() const;

    bool connectionStatus() const;

    Q_INVOKABLE static QVariant availablePorts();

    float xAxisValue() const;

    float yAxisValue() const;

public slots:
    void openCloseSerialPort(bool pEjectStatus);

    void setSelectedPortName(QString pSelectedPortName);

    void setXAxisValue(float xAxisValue);

    void setYAxisValue(float yAxisValue);

signals:
    void serialMessageChanged(QString serialMessage);

    void connectionStatusChanged(bool connectionStatus);

    void xAxisValueChanged(float xAxisValue);

    void yAxisValueChanged(float yAxisValue);

protected slots:
    void init();

private:
    void deserializeMessage(QByteArray pMessage);

    void setSerialMessage(QString serialMessage);

    void setConnectionStatus(bool connectionStatus);


private:
    QString                     mSerialMessage;
    QString                     mSelectedPortName;
    SerialCommunication         *mSerialCommunication;
    bool                        mConnectionStatus;
    float                       mXAxisValue;
    float                       mYAxisValue;
};

#endif // BCONTROLLER_H
