# Plotly dashboard tutorial
# https://dash.plotly.com/layout
# 

# Run this app with `python plotly-tutorial.py` and
# visit http://127.0.0.1:8050/ in your web browser.

# Import required libraries
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd

# Initialise the dashboard
app = dash.Dash(__name__)


# Import & set dataframe to use
# (assuming it is a "long-form" data frame)
# see https://plotly.com/python/px-arguments/ for more options
df = pd.DataFrame({
    "Fruit": ["Apples", "Oranges", "Bananas", "Apples", "Oranges", "Bananas"],
    "Amount": [4, 1, 2, 2, 4, 5],
    "City": ["NCL", "NCL", "NCL", "BNA", "BNA", "BNA"]
})

# Set visual parameters for presentation
colors = { # here we define the different colours (in hex) that we may use
    'background': '#34495E',
    'header' : '#ECF0F1',
    'text': '#95A5A6'
}
# Setup the figure to be displayed
# In this example, its a bar chart, showing the amount of fruit per city
fig = px.bar(df, x="City", y="Amount", color="Fruit", barmode="group")

fig.update_layout(
    plot_bgcolor=colors['background'],
    paper_bgcolor=colors['background'],
    font_color=colors['text']
)

# Here we define the layout of the dashboard (division of the page)
app.layout = html.Div(
    # Here we state the information about the background of this division
    style={'backgroundColor': colors['background']}, 
    
    children=[
    # This is primary header (H1)
    html.H1('Fruit x city amount', style={'textAlign': 'center','color':colors["header"]}),

    # This is the main text
    html.Div('''
        This passage here is the main-body of text that underlies the main header for the page.
    ''',style={'textAlign':'center','color':colors["text"]}),

    # This is the figure that the created above
    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

# Then we output the app to run on a local server
if __name__ == '__main__':
    app.run_server(debug=True) # as debug = True, then the page will refresh after an updated save