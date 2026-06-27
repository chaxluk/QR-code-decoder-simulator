#ifndef GRIDMODEL_H
#define GRIDMODEL_H

#include <QAbstractListModel>
#include <QVector>

class GridModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles { ColorRole = Qt::UserRole + 1 };

    explicit GridModel(QObject *parent = nullptr);

    // Функція малювання: приймає рядок, маску комп'ютера, маску гравця та довжину слова
    void populateDate(const QString &binaryString, int challengeMask, int playerMask, int dataLength);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override; // Повертає кількість елементів
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override; // Повертає значення для елемента
    QHash<int, QByteArray> roleNames() const override;

private:
    QVector<int> m_gridData; // Одномірний вектор для зберігання кольорів сітки (21x21 = 441 елемент)
    void setPixel(int row, int col, int value); // Встановлення значення конкретної клітини
    void drawFinderPattern(int startRow, int startCol); // Відрисовка великих квадратів
    void drawStaticScaffolding(int color); // Відрисовка службових ліній
    bool isReserved(int row, int col); // Перевірка, чи належить клітина до службових зон
    bool getMaskCondition(int maskId, int r, int c); // Математика масок в одному місці
};

#endif // GRIDMODEL_H