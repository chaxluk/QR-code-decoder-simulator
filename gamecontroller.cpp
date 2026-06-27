#include "gamecontroller.h"
#include <QDebug>
#include <QRandomGenerator>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>

GameController::GameController(QObject *parent) : QObject(parent) {}

QString GameController::loadRandomWord(int difficulty) {
    QString fileName;
    QString prefix = ":/QR_code_conundrum/";
    // Вибір файлу
    if (difficulty == 0) fileName = prefix + "words_easy.txt";
    else if (difficulty == 1) fileName = prefix + "words_normal.txt";
    else fileName = prefix + "words_hard.txt";

    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Помилка: не вдалося відкрити файл" << fileName;
        return "error";
    }

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    // Розбиваємо текст на слова (будь-які пробіли, таби або переноси рядків)
    QStringList words = content.split(QRegularExpression("\\s+"), Qt::SkipEmptyParts);

    if (words.isEmpty()) return "empty";

    int index = QRandomGenerator::global()->bounded(words.size());
    return words[index].toLower().trimmed(); // Слово в нижньому регістрі
}

void GameController::generateChallenge(int difficulty) {
    // Завантаження слова з файлу
    m_secretWord = loadRandomWord(difficulty);

    // Випадкова маска
    m_challengeMask = QRandomGenerator::global()->bounded(8);

    qDebug() << "Загадано слово з файлу:" << m_secretWord << "Маска:" << m_challengeMask;

    // Початковий стан
    processWord(m_secretWord, -1);
}
//Обробка слова й перетворення його в бінарний формат
void GameController::processWord(const QString &word, int playerMaskId) {
    // НЕ ПРАЦЮЄ, generateChallenge повертає рядок "error", якщо слово не було обранно зі списку
    QString actualWord = word.isEmpty() ? m_secretWord : word;

    if (actualWord.isEmpty())
        return;
    // Блок тип даних
    QString binaryResult = "0100";
    // Довжина слова
    binaryResult += QString("%1").arg(actualWord.length(), 8, 2, QChar('0'));
    // Перетворення символів в UTF-8, а потім у 8 біт
    QByteArray bytes = actualWord.toUtf8();
    for (char b : bytes) {
        binaryResult += QString("%1").arg((quint8)b, 8, 2, QChar('0'));
    }

    binaryResult += "0000"; // Термінатор
    int dataLength = binaryResult.length();

    // Генерація рандомного шуму (208 біт)
    while (binaryResult.length() < 208) {
        binaryResult += QString::number(QRandomGenerator::global()->bounded(2));
    }

    m_gridModel.populateDate(binaryResult, m_challengeMask, playerMaskId, dataLength);
}

void GameController::saveWin(int difficulty, int score, int time) {
    QSettings settings("MyCoursework", "QRGame");
    QString prefix = (difficulty == 0) ? "easy_" : (difficulty == 1) ? "normal_" : "hard_";

    // 1. Кількість ігор
    int games = settings.value(prefix + "games", 0).toInt();
    settings.setValue(prefix + "games", games + 1);

    // 2. Загальний рахунок на цій складності
    int total = settings.value(prefix + "totalScore", 0).toInt();
    settings.setValue(prefix + "totalScore", total + score);

    // 3. Рекорд по очках
    int bestS = settings.value(prefix + "bestScore", 0).toInt();
    if (score > bestS) settings.setValue(prefix + "bestScore", score);

    // 4. Рекорд по часу - тут чим менше, тим краще
    int bestT = settings.value(prefix + "bestTime", 0).toInt();
    if (bestT == 0 || time < bestT) settings.setValue(prefix + "bestTime", time);

    settings.sync();
}
// Кількість ігор для певної складнотсі
int GameController::getGamesWon(int difficulty) {
    QSettings settings("MyCoursework", "QRGame");
    QString prefix = (difficulty == 0) ? "easy_" : (difficulty == 1) ? "normal_" : "hard_";
    return settings.value(prefix + "games", 0).toInt();
}
// Загальний рахунок для певної складності
int GameController::getTotalScore(int difficulty) {
    QSettings settings("MyCoursework", "QRGame");
    QString prefix = (difficulty == 0) ? "easy_" : (difficulty == 1) ? "normal_" : "hard_";
    return settings.value(prefix + "totalScore", 0).toInt();
}
// найкращий результат по очках
int GameController::getBestScore(int difficulty) {
    QSettings settings("MyCoursework", "QRGame");
    QString prefix = (difficulty == 0) ? "easy_" : (difficulty == 1) ? "normal_" : "hard_";
    return settings.value(prefix + "bestScore", 0).toInt();
}
// Найкращий час проходження
int GameController::getBestTime(int difficulty) {
    QSettings settings("MyCoursework", "QRGame");
    QString prefix = (difficulty == 0) ? "easy_" : (difficulty == 1) ? "normal_" : "hard_";
    return settings.value(prefix + "bestTime", 0).toInt();
}

void GameController::resetStats() {
    QSettings settings("MyCoursework", "QRGame");
    settings.clear(); // Видаляє всі збережені дані
}
// Перевірка відповіді
bool GameController::checkAnswer(const QString &playerAnswer) {
    QString cleanedAnswer = playerAnswer.trimmed().toLower();
    QString cleanedSecret = m_secretWord.toLower();

    return cleanedAnswer == cleanedSecret;
}

GridModel* GameController::gridModel() {
    return &m_gridModel;
}