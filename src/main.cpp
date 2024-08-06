#include <QApplication>
#include "bcontroller.h"
#include <QDebug>
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QApplication app(argc, argv);

    app.setApplicationVersion("v1.0");
    app.setApplicationName("Quadrant Detector");
    app.setWindowIcon(QIcon(":/ui/images/quadrant_icon.png"));

    QSize tSize(850,850);

    BController controller;
    controller.setMinimumSize(tSize);
    controller.setMaximumSize(tSize);
    controller.setColor(Qt::black);
    controller.show();

    return app.exec();
}
