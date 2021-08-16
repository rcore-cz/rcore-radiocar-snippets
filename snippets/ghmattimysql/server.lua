function MySQLSyncfetchAll(query, table, cb)
    return exports['ghmattimysql']:executeSync(query, table, cb)
end

function MySQLAsyncfetchAll(query, table, cb)
    return exports['ghmattimysql']:execute(query, table, cb)
end

---
-- sync / async

function MySQLSyncexecute(query, table, cb)
    return exports['ghmattimysql']:executeSync(query, table, cb)
end

function MySQLAsyncexecute(query, table, cb)
    return exports['ghmattimysql']:execute(query, table, cb)
end