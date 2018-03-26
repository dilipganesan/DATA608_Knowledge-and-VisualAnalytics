#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 19 13:32:09 2018

@author: dilipganesan

DATA609 - Project 4.

Question 2 :
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objs as go
import pandas as pd
import seaborn as sns; sns.set(style="white", color_codes=True)


df = pd.read_csv(
    'https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module4/Data/riverkeeper_data_2013.csv')

app = dash.Dash()
    
available_indicators = df['Site'].unique()

df['EnteroCount'] = df['EnteroCount'].str.replace('[^\w\s]','')
df['EnteroCount'] = pd.to_numeric(df['EnteroCount'])

app.layout = html.Div(children=[
        
    html.H1(children='RiverKeeper.Org'),

    html.Div(children='''
        Dash Application: Relationship Between Rain Fall and Entero Counts for Selected Site.
    '''),
    #generate_table(df)
    
   html.Div([
            dcc.Dropdown(
                id='inputSite',
                options=[{'label': i, 'value': i} for i in available_indicators],
                value='Select The Site'
            )
        ],
        style={'width': '48%', 'display': 'inline-block'}),
   dcc.Graph(id='output-container'),

])
    
@app.callback(
    dash.dependencies.Output('output-container', 'figure'),
    [dash.dependencies.Input('inputSite', 'value')])
def update_output(value):
    newdf = df.loc[df['Site'] == value]
    rg=sns.regplot("FourDayRainTotal", "EnteroCount", newdf)
    X=rg.get_lines()[0].get_xdata()
    Y=rg.get_lines()[0].get_ydata()
    
    p1 = go.Scatter(
                  x=newdf['FourDayRainTotal'],
                  y=newdf['EnteroCount'],
                  mode='markers',
                  marker=go.Marker(color='rgb(255, 127, 14)'),
                  name='Data'
                  )
    p2 = go.Scatter(
                  x=X,
                  y=Y,
                  mode='lines',
                  marker=go.Marker(color='rgb(31, 119, 180)'),
                  name='Fit'
                  )
    


    layout = go.Layout(
                title="Linear Regression Plot", xaxis={'title':'Four Day Rain Total'}, yaxis={'title':'Entero Count'}
                )
  

    
    return {
       'data' : [p1,p2],
       'layout' : layout

    
    }
        
 


if __name__ == '__main__':
    app.run_server(debug=True)