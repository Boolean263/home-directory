-- Lua plugin for Wireshark. Create a field to briefly show the lower port number,
-- and whether this packet is going to or coming from that port.
-- Created because I generally only care about the port number of the server,
-- which is generally lower than the port number of the client.
--
-- This may be slightly overengineered, but I'm trying to keep the rust off my Lua.
--
-- To automatically load with Wireshark/Tshark, run `tshark -G folders` and then
-- place this script in the folder it shows for "Personal Lua Plugins".

-- Don't load if we're running in the Wireshark test suite, to reduce the chance
-- of interfering with test results.
if os.getenv("PYTEST_CURRENT_TEST") then
    return
end

-- Show info in Plugins tab of "About Wireshark"
set_plugin_info({
    ["version"] = "0.1.0",
    ["author"] = "David Perry",
    ["description"] = "Fields to show the service port in use",
})


local MAX_PORT = 49152

local p = Proto("SVCPORT", "Service Port")
local fields = {
    ["svcport"] = ProtoField.new("Service Port", "svcport.port", ftypes.STRING,
                    nil, base.UNICODE),
    ["is_client"] = ProtoField.new("Sender is client", "svcport.is_client", ftypes.BOOLEAN,
                    nil, base.NONE),
    ["is_server"] = ProtoField.new("Sender is server", "svcport.is_server", ftypes.BOOLEAN,
                    nil, base.NONE),
}
p.fields = fields

-- Fields that this postdissector will be looking for
local extractors = {
    ["udp"] = {
        ["src"] = Field.new("udp.srcport"),
        ["dst"] = Field.new("udp.dstport"),
    },
    ["tcp"] = {
        ["src"] = Field.new("tcp.srcport"),
        ["dst"] = Field.new("tcp.dstport"),
    },
}

-- The (post)dissector itself
function p.dissector(tvb, pinfo, tree)
    local t = tvb(0, 0)
    local subtree = nil
    for l4, ports in pairs(extractors) do
        local sports = { ports.src() }
        local dports = { ports.dst() }
        local dir
        for i = 1, #sports do
            local sport = sports[i].value
            local dport = dports[i].value
            if sport <= MAX_PORT or dport <= MAX_PORT then
                if not subtree then
                    subtree = tree:add(p, t)
                end
                if dport > sport then
                    dir = "←"..tostring(sport)
                    subtree:add(fields.is_server, t, true):set_generated()
                elseif dport < sport then
                    dir = "→"..tostring(dport)
                    subtree:add(fields.is_client, t, true):set_generated()
                else
                    dir = "↔"..tostring(dport)
                end
                subtree:add(fields.svcport, t, dir):set_generated()
                subtree:append_text(" "..dir)
            end
        end
    end
end

register_postdissector(p)

-- vim:shiftwidth=4:fileencoding=utf-8:
