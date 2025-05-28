@echo off
swiftc main.swift core.swift socket.swift -o server.exe
server.exe
pause