const values = require('./defaultValues');
const fs = require('fs');

function generateExpenses() {
    return (values.default.minExpenses + (Math.random() * (values.default.maxExpenses - values.default.minExpenses)));
}

function getNumberOfDaysPerMonth(month) {
    switch (month) {
        case 0:
        case 2:
        case 4:
        case 6:
        case 7:
        case 9:
        case 11:
            return 31;
        case 1:
            return 28;
        default:
            return 30;
    }
}

function formatDate(month, year, day) {
    let strMonth = month.toString();
    if (strMonth.length < 2)
        strMonth = '0' + strMonth;

    if (day === undefined)
        return [year.toString(), strMonth].join('-');

    let strDay = day.toString();
    if (strDay.length < 2)
        strDay = '0' + strDay;
    return [year.toString(), strMonth, strDay].join('-');
}

function generateCSV(month, year, expenses) {
    let headline = "";

    for (let i = 0; i < expenses.length; i++) {
        headline += "expenses," + formatDate((month + 1), year, (i + 1)) + "," + expenses[i].toFixed(2) + "\n";
    }
    fs.writeFile('generated/expenses-' + formatDate((month + 1), year) + '.csv', headline, function (err) {
        if (err) return console.log(err);
        console.log('wrote ' + values.default.months[month] + ' ' + year + ' CSV.');
    });
}

function generateMonth(month, year) {
    const daysNumber = getNumberOfDaysPerMonth(month);
    const expenses = [];
    let total = 0.0;

    for (let i = 0; i < daysNumber; i++) {
        expenses.push(generateExpenses());
        total += expenses[i];
    }

    //Debug
    console.log("For " + values.default.months[month] + " " + year + ": " + total + "€")

    generateCSV(month, year, expenses);
}

function generateYear(i) {
    const years = values.default.beginYear + i;

    for (let j = 0; j < 12; j++) {
        generateMonth(j, years);
    }
}

(function () {
    for (let i = 0; i < values.default.years; i++) {
        generateYear(i);
    }
})();