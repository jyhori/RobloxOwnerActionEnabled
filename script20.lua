--[[
stats.lua
Утилита для быстрого расчёта статистики по набору чисел,
сохранённых в CSV‑файле.
Формат CSV: каждый столбец – отдельное число (int/float), строки – отдельные наблюдения.
Программа поддерживает:
• Путь к файлу передаётся через аргумент командной строки.
• Опциональные колонки (по умолчанию берётся первая колонка).
• Ошибки ввода‑вывода и некорректные данные обрабатываются без падения.
• Вывод результатов в консоль и в файл "report.txt".
--]]

-- ----------------------------------------------------------------------
-- 1. Вспомогательные функции
-- ----------------------------------------------------------------------
local function split_csv(line)
-- Простой разбор CSV без экранирования/кавычек (подходит для чисел без запятых).
-- Возвращает таблицу строк (по каждой колонке строки в столбце).
local cols = {}
for val in line:gmatch("%S+") do
table.insert(cols, tonumber(val))
end
return cols
end

local function trim(s)
-- Убираем пробельные символы с начала и конца строки.
return s:match "^%s*(.-)%s*$"
end

local function parse_args()
-- Поддержка простого CLI: 1 аргумент – путь к CSV.
local args = {...}
if #args ~= 1 then
io.stderr:write("Usage: lua stats.lua \n")
return nil
end
return trim(args[1])
end

local function open_file(filepath)
local f, err = io.open(filepath, "r")
if not f then
io.stderr:write("Error opening file: " .. err .. "\n")
return nil, err
end
return f
end

-- ----------------------------------------------------------------------
-- 2. Основной код
-- ----------------------------------------------------------------------
local input_path = parse_args()
if not input_path then return end -- Останавливаем скрипт при неправильном вводе.

local file, err = open_file(input_path)
if not file then return end -- Дальнейшее выполнение бессмысленно.

local col_index = 1 -- По умолчанию будем использовать первую колонку.
local numbers = {} -- Таблица для всех чисел.
local line_no = 0

while true do
local line = file:read("*line")
if not line then break end
line_no = line_no + 1

-- Пропускаем пустые строки и заголовки (строки без чисел)
if line:match "^%s*$" then
continue
end

local cols = split_csv(line)

if #cols == 0 then
io.stderr:write("Line "..line_no..": empty line ignored.\n")
continue
end

-- Если указали несколько колонок, проверяем, что нужного нам столбца нет в строке:
if col_index > #cols then
io.stderr:write("Line "..line_no..": not enough columns (expected "..col_index..", got "..#cols..")\n")
continue
end

local val = cols[col_index]
if val == nil then
io.stderr:write("Line "..line_no..": missing value in column "..col_index.."\n")
continue
end

if type(val) ~= "number" then
io.stderr:write("Line "..line_no..": invalid number in column "..col_index..": '"..val.."'\n")
continue
end

table.insert(numbers, val)
end

file:close()

if #numbers == 0 then
io.stderr:write("No valid numeric data found. Exiting.\n")
return
end

-- ----------------------------------------------------------------------
-- 3. Статистические расчёты
-- ----------------------------------------------------------------------
local sum = 0
local min = numbers[1]
local max = numbers[1]

for _, v in ipairs(numbers) do
sum = sum + v
if v < min then min = v end
if v > max then max = v end
end

local avg = sum / #numbers
local median = 0
-- Для median сортируем массив.
local sorted = {}
for _, v in ipairs(numbers) do table.insert(sorted, v) end
table.sort(sorted)

if #sorted % 2 == 1 then
median = sorted[math.ceil(#sorted / 2)]
else
median = (sorted[#sorted / 2] + sorted[#sorted / 2 + 1]) / 2
end

-- ----------------------------------------------------------------------
-- 4. Вывод результатов
-- ----------------------------------------------------------------------
print("=== Статистика по столбцу "..col_index.." из "..input_path.." ===")
print(string.format("Кол-во значений : %d", #numbers))
print(string.format("Сумма : %.6f", sum))
print(string.format("Среднее : %.6f", avg))
print(string.format("Минимум : %.6f", min))
print(string.format("Максимум : %.6f", max))
print(string.format("Медиана : %.6f", median))

-- Запись в файл отчёта
local report_file, rerr = io.open("report.txt", "w")
if not report_file then
io.stderr:write("Error creating report.txt: "..rerr.."\n")
else
report_file:write("=== Статистика по столбцу "..col_index.." из "..input_path.." ===\n")
report_file:write(string.format("Кол-во значений : %d\n", #numbers))
report_file:write(string.format("Сумма : %.6f\n", sum))
report_file:write(string.format("Среднее : %.6f\n", avg))
report_file:write(string.format("Минимум : %.6f\n", min))
report_file:write(string.format("Максимум : %.6f\n", max))
report_file:write(string.format("Медиана : %.6f\n", median))
report_file:close()
print("Отчёт сохранён в файл report.txt")
end


---
