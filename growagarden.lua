-- Remote Spy Logger for Grow a Garden
-- This will detect all RemoteEvents and RemoteFunctions triggered by the client

local function logRemote(name, args)
    print("[REMOTE FIRED] " .. name)
    for i, v in pairs(args) do
        print(" Arg[" .. i .. "]:", v)
    end
end

-- Hook RemoteEvents
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        local original = v.FireServer
        v.FireServer = function(self, ...)
            logRemote(self:GetFullName(), {...})
            return original(self, ...)
        end
    elseif v:IsA("RemoteFunction") then
        local original = v.InvokeServer
        v.InvokeServer = function(self, ...)
            logRemote(self:GetFullName(), {...})
            return original(self, ...)
        end
    end
end

print("[+] Remote Logger Initialized.")
