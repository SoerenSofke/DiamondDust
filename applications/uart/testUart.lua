Luaunit = require('luaunit')
Serial = require('periphery').Serial


TestSuite = {}
function TestSuite:setUp()
    local command = 'iceprog -S vexUart.bin'
    os.execute(command .. ' >/dev/null 2>&1')
    Serial = Serial("/dev/serial0", 115200)
end

function TestSuite:testStringReceived()
    local buf = Serial:read(128, 500)
    Luaunit.assertStrContains(buf, 'Hello Soeren Sofke and Sebastian Zanker!!!')
end

function TestSuite:tearDown()
    Serial:close()
end

os.exit(Luaunit.LuaUnit.run())