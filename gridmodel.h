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

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    QVector<int> m_gridData;
    void setPixel(int row, int col, int value);
    void drawFinderPattern(int startRow, int startCol);
    void drawStaticScaffolding(int color);
    bool isReserved(int row, int col);
    bool getMaskCondition(int maskId, int r, int c); // Математика масок в одному місці
};

#endif // GRIDMODEL_H