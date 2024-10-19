# Behavior Subject

It's a solution for emitting events, much like a pipe in inter process communication. It comes from the [rxjs](https://rxjs.dev/api/index/class/BehaviorSubject) library. I used this with Angular when working on a dashboard project for one of the companies.

## Problem
If you have used [chart.js](https://www.chartjs.org/) you would know it's a very good library for rendering charts on frontend. I had to tweak the default behavior of the legend click in one of the charts, so I had to add a callback function for this behavior in the `chartOptions` which I generated from a class called `chart.service.ts`.
Now I had a frontend component (let's call it `mychart.component.ts`) which had this `chartService` in its constructor.

```js title="my-chart.component.ts"
import { ChartService } from 'chart.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'my-chart',
  templateUrl: './my-chart.component.html',
  styleUrls: ['./my-chart.component.css']
})
export class MyChartComponent implements OnInit {
    constructor(private chartService: ChartService) {}

    ngOnInit() {
        // do some cool thing with chartService
    }
}
```

```js title="chart.service.ts"
import { Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root'
})
export class ChartService {

    selectedLegendItems: string[] = [];

    getChartOptions() {
        return {
            legend: {
                display: true,
                onClick : function (e, legendItem, legend) {
                    // some complicated logic using legend items
                    if (someCondition) {
                        // updated selectedLegendItems array
                        selectedLegendItems.push(legendItem)
                    }
                }
            },
            labels: {
                color: 'rgb(255, 99, 132)'
            }
        };
    };

```

Now the problem is, I wanted to use the `selectedLegendItems` array in the component file since I had to make an API call using that array. I basically wanted to emit back the array from the service to the component which had the service already injected. At first this problem might look difficult to solve, but
if you know anything about behavior subjects, you would know how to get around this.

```js title="chart.service.ts"
import { BehaviorSubject } from 'rxjs';
...
export class ChartService {

    private selectedLegendItems= new BehaviorSubject([]);
    currentlySelectedLegendItems = this.selectedLegendItems.asObservable();
...
                onClick : function (e, legendItem, legend) {
                    // some complicated logic using legend items
                    if (someCondition) {
                        // updated selectedLegendItems array
                        tempArray.push(legendItem)
                    }
                    this.selectedLegendItems.next(tempArray);
                }
...
```

And now this can be conviniently consumed by the component like so

```js title="my-chart.component.ts"
...
    constructor(private chartService: ChartService) {}

    ngOnInit() {
        // do some cool thing with chartService
        this.chartService.currentlySelectedLegendItems.subscribe((items) => { /* some HTTP call using items array */ });:w
    }
}
...
```
