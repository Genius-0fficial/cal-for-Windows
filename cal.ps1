# function to get days in month
function Get-DaysInMonth {
  param (
    [int]$Month,
    [int]$Year
  )
  # check is data correct
  if ($Month -lt 1 -or $Month -gt 12) {
    Write-Error "Неверный номер месяца: $Month"
    return
  }
  if ($Year -lt 1) {
    Write-Error "Неверный номер года: $Year"
    return
  }
  # arrays of days in each month
  $days = @(31,28,31,30,31,30,31,31,30,31,30,31)
  if ($Month -eq 2 -and (Test-Path variable:/leap)) {
    return $days[$Month-1] + 1
  }
  else {
    return $days[$Month-1]
  }
}

function Test-LeapYear {
  param (
    [int]$Year
  )
  if ($Year -lt 1) {
    Write-Error "Неверный номер года: $Year"
    return
  }
  # Algoritm to chech leap year
  if ($Year % 4 -ne 0) {
    return $false
  }
  elseif ($Year % 100 -ne 0) {
    return $true
  }
  elseif ($Year % 400 -ne 0) {
    return $false
  }
  else {
    return $true
  }
}

function Show-Calendar {
  param (
    [int]$Month = (Get-Date).Month,
    [int]$Year = (Get-Date).Year
  )
  if ($Month -lt 1 -or $Month -gt 12) {
    Write-Error "Неверный номер месяца: $Month"
    return
  }
   if ($Year -lt 1) {
    Write-Error "Неверный номер года: $Year"
    return
   }

   # array with month names
   $months = @("Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь")

   # put year state (leap or not) leap variable
   if (Test-LeapYear -Year $Year) {
     Set-Variable -Name leap -Value $true -Scope Script
   }
   else {
     Set-Variable -Name leap -Value $false -Scope Script
   }

   # count days in month
   $days = Get-DaysInMonth -Month $Month -Year $Year

   # get day number
   $firstDay = (Get-Date -Day 1 -Month $Month -Year $Year).DayOfWeek.value__

   # calendar title with year at the center
   Write-Host ("`n" + $months[$Month-1] + " " + $Year).PadLeft(20).PadRight(20)

   # Short names of days
   Write-Host "Вс Пн Вт Ср Чт Пт Сб"

   # Выводим пустые ячейки до первого числа месяца
   for ($i = 0; $i -lt $firstDay; $i++) {
     Write-Host "  " -NoNewline
   }

   # number of month 
   for ($i = 1; $i -le $days; $i++) {
     Write-Host ("{0,2}" -f $i) -NoNewline
     if (($firstDay + $i) % 7 -eq 0) {
       Write-Host
     }
     else {
       Write-Host " " -NoNewline
     }
   }
   Write-Host
}

# Call Show-Calendar function 
Show-Calendar -Month (Get-Date).Month -Year (Get-Date).Year
