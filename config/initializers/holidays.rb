# holidaysライブラリを利用して日本の祝日を適用
# config/initializers/holidays.rb
require 'holidays'
Holidays.cache_between(Date.civil(2024, 1, 1), Date.civil(2025, 12, 31), :jp)
