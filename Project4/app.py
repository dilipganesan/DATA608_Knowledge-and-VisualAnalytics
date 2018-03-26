#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 17 13:32:09 2018

@author: dilipganesan

DATA609 - Project 4.

Question 1 :
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import dash_table_experiments as dt
import plotly.graph_objs as go
import pandas as pd

df = pd.read_csv(
    'https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module4/Data/riverkeeper_data_2013.csv')

app = dash.Dash()


def generate_table(df, max_rows=df.shape[0]):
    return html.Table(
        # Header
        [html.Tr([html.Th(col) for col in df.columns])] +

        # Body
        [html.Tr([
            html.Td(df.iloc[i][col]) for col in df.columns
        ]) for i in range(min(len(df), max_rows))]
    )
    
available_indicators = df['Date'].unique()

df['EnteroCount'] = df['EnteroCount'].str.replace('[^\w\s]','')
df['EnteroCount'] = pd.to_numeric(df['EnteroCount'])

app.layout = html.Div(children=[
        
    html.H1(children='RiverKeeper.Org'),

    html.Div(children='''
        Dash Application: Please Select a Date to Know about EnteroCount at Different Sites
    '''),
    #generate_table(df)
    
   html.Div([
            dcc.Dropdown(
                id='inputDate',
                options=[{'label': i, 'value': i} for i in available_indicators],
                value='Select The Date'
            )
        ],
        style={'width': '48%', 'display': 'inline-block'}),
   dcc.Graph(id='output-container'),
   
   html.Div(children='''
        The Lesser the Value of Enterococcus, Site is Safe for Kayaking.
    '''),
   
   #html.Div(id='tableout', style={'display':'table'})
   dt.DataTable(
        # Initialise the rows
        rows=[{}],
        row_selectable=True,
        filterable=True,
        sortable=True,
        selected_row_indices=[],
        id='table'
    )
   

])
    
@app.callback(
    dash.dependencies.Output('output-container', 'figure'),
    [dash.dependencies.Input('inputDate', 'value')])
def update_output(value):
    newdf = df.loc[df['Date'] == value]
    top10site = newdf.groupby(newdf['Site'])["EnteroCount"].mean().reset_index()
    top10site = top10site.sort_values(by='EnteroCount', ascending=False)
    generate_table(top10site)
    return {
    'data' : [go.Bar(
            x=top10site['EnteroCount'],
            y=top10site['Site'],
            orientation='h'
    )]

    
    }
        
        
@app.callback(
    dash.dependencies.Output('table', 'rows'),
    [dash.dependencies.Input('inputDate', 'value')])
def update_table(value):
    newdf = df.loc[df['Date'] == value]
    top10site = newdf.groupby(newdf['Site'])["EnteroCount"].mean().reset_index()
    top10site = top10site.sort_values(by='EnteroCount', ascending=True)
    return top10site.to_dict('records')
    


if __name__ == '__main__':
    app.run_server(debug=True)