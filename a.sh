
# Sviridov Ivan СКБ182
# Вариант 5
# Написать программу вывода календаря текущего месяца текущего года и по введенной дате определить день недели.
# Предусмотреть возможность неоднократного прерывания выполнения программы от клавиатуры.
# При поступлении трех сигналов прерывания вывести информацию о том, сколько дней в указанном году.

counter=0 # счетчик прерываний
flag=0 # счетчик прерываний
flag_c=0 # счетчик прерываний
k=0 # обнуление для записи количества дней
year='a' # для проверки

sigactionHandler() {
    if test "$year" = a
    then
      echo "error" # вывод ошибки
    else
      ostatok=`expr $year % 4` # берем остаток
      if test $ostatok -eq 0 # проверка на високосность
      then
        k=366 # количество дней в году
      else
        k=365 # количество дней в году
      fi
    fi

    flag=1

    counter=`expr $counter + 1` # счетчик прерываний
    flag_c=`expr $flag_c + 1` # счетчик флага на прерывания
    if test $counter -eq 3 # если количетсво прерываний равно 3
    then
        echo '' #красота
        echo $k # вывод количества дней в году
    fi
}

trap 'sigactionHandler' 2 # перехват сигнала прерывания SIGINT

ncal # вывод календаря текущего месяца и года

while :
do
  read -p 'Enter the date in the format 2016-03-16 or enter q to leave programm ' data # ввод даты
  echo '' # красота
  if test $flag -eq 1 # проверка на поступление прерываний
  then
    flag=0
    continue
  fi
  if test "$data" = q #выход из программы, если ввели q
  then
    exit 0
  else
    sleep 2 # для ввода прерываний
    year=`echo $data | cut -b 1,2,3,4` # определение года
    sleep 2 # для ввода прерываний
    moth=`echo $data | cut -b 6,7` # определение месяца
    day=`echo $data | cut -b 9,10` # определение дня
    check1=`expr $day / 10`
    check2=`expr $day % 10`
    sleep 1 # для ввода прерываний
    if test $check1 -eq 0
    then
      day_s=" ${check2} "
    else
      day_s="$day"
    fi
    ncal -d $year'-'$month # календарь выбранного года и месяца
    ostatok=`expr $year % 4` # определение остатка
    if test $ostatok -eq 0 # определение количества дней в году
    then
      k=366 # високосный год
    else
      k=365 # обычный год
    fi
    ncal -d $year'-'$month | grep "$day_s" | cut -b 1,2  # день недели
    if test $flag_c -gt 2 # если количетсво прерываний больше 3
    then
      echo $k # вывод количества дней в году
      flag=0 # обнуление прерываний
    fi
  fi
done
