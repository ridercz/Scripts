@echo off
dotnet tool install Altairis.Tmd.Compiler
dotnet tmdc activate.md
dotnet EmbedDataUri.cs
del activate.md.html