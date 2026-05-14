#include "gridmodel.h"

GridModel::GridModel(QObject *parent): QAbstractListModel(parent) {}

int GridModel::rowCount(const QModelIndex &parent) const {
    return parent.isValid() ? 0 : m_gridData.size();
}

QVariant GridModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || role != ColorRole) return QVariant();
    return m_gridData.at(index.row());
}

QHash<int, QByteArray> GridModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ColorRole] = "cellColor";
    return roles;
}

void GridModel::setPixel(int row, int col, int value) {
    if (row >= 0 && row < 21 && col >= 0 && col < 21) {
        m_gridData[row * 21 + col] = value;
    }
}

bool GridModel::getMaskCondition(int maskId, int r, int c) {
    if (maskId == -1) return false;
    switch(maskId) {
    case 0: return ((r + c) % 2 == 0); //000
    case 1: return (r % 2 == 0); // 001
    case 2: return (c % 3 == 0); //010
    case 3: return ((r + c) % 3 == 0); //011
    case 4: return (((r / 2) + (c / 3)) % 2 == 0); //100
    case 5: return (((r * c) % 2) + ((r * c) % 3) == 0); //101
    case 6: return ((((r * c) % 2) + ((r * c) % 3)) % 2 == 0); //110
    case 7: return ((((r + c) % 2) + ((r * c) % 3)) % 2 == 0); //111
    default: return false;
    }
}

void GridModel::drawFinderPattern(int startRow, int startCol) {
    for (int r = 0; r < 7; ++r) {
        for (int c = 0; c < 7; ++c) {
            if (r == 0 || r == 6 || c == 0 || c == 6) setPixel(startRow + r, startCol + c, 1);
            else if (r == 1 || r == 5 || c == 1 || c == 5) setPixel(startRow + r, startCol + c, 0);
            else setPixel(startRow + r, startCol + c, 1);
        }
    }
}

void GridModel::drawStaticScaffolding(int color) {
    for (int i = 8; i < 13; ++i) { // Пунктир
        if (i % 2 == 0) { setPixel(6, i, color); setPixel(i, 6, color); }
    }
    for (int i = 0; i <= 8; ++i) { setPixel(8, i, color); setPixel(i, 8, color); } // Формат
    for (int i = 13; i <= 20; ++i) { setPixel(8, i, color); setPixel(i, 8, color); }
    setPixel(13, 8, color); // Dark Module
}

bool GridModel::isReserved(int row, int col) {
    if (row == 8 || col == 8) return true;
    if (row < 8 && col < 8) return true;
    if (row < 8 && col > 12) return true;
    if (row > 12 && col < 8) return true;
    if (row == 6 || col == 6) return true;
    return false;
}

void GridModel::populateDate(const QString &binaryString, int challengeMask, int playerMask, int dataLength) {
    beginResetModel();
    m_gridData.clear();
    for(int i = 0; i < 441; ++i) m_gridData.append(0);

    drawFinderPattern(0, 0);
    drawFinderPattern(0, 14);
    drawFinderPattern(14, 0);
    drawStaticScaffolding(4); // Синій каркас

    // Підказка маски комп'ютера (Кольори 2 та 3)
    if (challengeMask >= 0) {
        int b1 = (challengeMask & 4) ? 2 : 3;
        int b2 = (challengeMask & 2) ? 2 : 3;
        int b3 = (challengeMask & 1) ? 2 : 3;
        setPixel(8, 2, b1); setPixel(8, 3, b2); setPixel(8, 4, b3); // Гориз.
        setPixel(18, 8, b1); setPixel(17, 8, b2); setPixel(16, 8, b3); // Вертик.
    }

    int bitIndex = 0, direction = -1, row = 20, col = 20;
    while (col > 0) {
        if (col == 6) col--;
        while (row >= 0 && row < 21) {
            for (int i = 0; i < 2; ++i) {
                int cCol = col - i;
                if (!isReserved(row, cCol) && bitIndex < binaryString.length()) {
                    int bit = (binaryString.at(bitIndex) == '1') ? 1 : 0;
                    // ПОДВІЙНИЙ XOR: Дані ^ Маска_ПК ^ Маска_Гравця
                    bool m1 = getMaskCondition(challengeMask, row, cCol);
                    bool m2 = getMaskCondition(playerMask, row, cCol);
                    int finalBit = bit ^ (m1 ? 1 : 0) ^ (m2 ? 1 : 0);

                    if (finalBit == 1) {
                        setPixel(row, cCol, (bitIndex < dataLength) ? 1 : 4);
                    } else setPixel(row, cCol, 0);
                    bitIndex++;
                }
            }
            row += direction;
        }
        direction = -direction; row += direction; col -= 2;
    }
    endResetModel();
}