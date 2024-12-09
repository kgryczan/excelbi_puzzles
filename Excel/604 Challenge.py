import pandas as pd
from plotnine import *
from datetime import datetime
import numpy as np

path = "604 Transform Table.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=11, dtype={"System No": str, "Stage": str, "Finish": str, "Start": str})

input['Finish'] = pd.to_datetime(input['Finish'])
input['Start'] = pd.to_datetime(input['Start'])

result = (input
          .assign(month=lambda x: x['Finish'].dt.to_period('M').dt.to_timestamp())
          .sort_values(by=['Finish'])
          .assign(rank=lambda x: x.groupby(['month', 'Stage']).cumcount() + 1)
          .assign(val=lambda x: np.where(x['Stage'] == "Pre-Comm", -1, 1))
          .sort_values(by=['Stage', 'month', 'rank']))

lims = [datetime(2024, 5, 15), datetime(2024, 9, 15)]

top = (ggplot(result, aes(x='month', y='val', label='System No'))
       + scale_x_datetime(date_breaks='1 month', date_labels='%b %Y', limits=lims)
       + geom_bar(stat='identity', position='stack', fill='white')
       + geom_text(position=position_stack(vjust=0.5), size=8)
       + annotate('text', x=lims[0], y=1.5, label="Construction", angle=90, color="black")
       + annotate('text', x=lims[0], y=-1.2, label="Pre-Comm", angle=90, color="black")
       + geom_hline(yintercept=0, size=2, color="black")
       + theme(panel_grid_major=element_blank(),
               panel_grid_minor=element_blank(),
               panel_border=element_blank(),
               axis_text_y=element_blank(),
               axis_title_y=element_blank(),
               axis_title_x=element_blank(),
               axis_ticks_y=element_blank(),
               legend_position='none'))

qplot(top)