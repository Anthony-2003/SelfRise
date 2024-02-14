const db = require("./db");

async function read(chatId) {
    const rows = await db.query(`
        SELECT * FROM chat WHERE id = ?
    `, [chatId]);

    return rows[0];
}

async function create({ userId, text }) {
    const rows = await db.query(`
    INSERT INTO chat(id_usuario, contenido, fecha)
    VALUES(?, ?, NOW())
    `, [userId, text]);

    const insertId = rows.insertId;

    return { insertId };
}

module.exports = {
    read,
    create
};