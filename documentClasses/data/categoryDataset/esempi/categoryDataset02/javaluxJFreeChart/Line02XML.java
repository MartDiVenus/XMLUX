/* ===========================================================
 * JFreeChart : a free chart library for the Java(tm) platform
 * ===========================================================
 *
 * (C) Copyright 2000-2004, by Object Refinery Limited and Contributors.
 *
 * Project Info:  http://www.jfree.org/jfreechart/index.html
 *
 * This library is free software; you can redistribute it and/or modify it under the terms
 * of the GNU Lesser General Public License as published by the Free Software Foundation;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with this
 * library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * [Java is a trademark or registered trademark of Sun Microsystems Inc. (Mario: Oracle now), 
 * in the United States and other countries.]
 *
 * (C) Copyright 2002-2004, by Object Refinery Limited and Contributors.
 *
 * Original Author:  David Gilbert (for Object Refinery Limited);
 * Contributor(s):   -;
*/
 
// ****************************************************************************
    // * JFREECHART DEVELOPER GUIDE                                               *
    // * The JFreeChart Developer Guide, written by David Gilbert, is available   *
    // * to purchase from Object Refinery Limited:                                *
    // *                                                                          *
    // * http://www.object-refinery.com/jfreechart/guide.html                     *
    // *                                                                          *
    // * Sales are used to provide funding for the JFreeChart project - please    * 
    // * support us so that we can continue developing free software.             *
// ****************************************************************************

import java.io.*;
import java.io.InputStream;
import org.jfree.data.category.DefaultCategoryDataset; 
import org.jfree.chart.ChartUtilities; 
import org.jfree.data.xml.DatasetReader;

import java.awt.Color;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;

import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;

 public class Line02XML {  
        
        public static void main(String[] args) throws Exception{
	                DefaultCategoryDataset my_line_02_dataset = new DefaultCategoryDataset();
                File my_file=new File("prova.xml");           
                my_line_02_dataset = (DefaultCategoryDataset) DatasetReader.readCategoryDatasetFromXML(my_file);
        
            JFreeChart  NsimoObject = ChartFactory.createLineChart(
            "Line Chart Demo 1",       // chart title
            "Type",                    // domain axis label
            "Value",                   // range axis label
            my_line_02_dataset,                   // data
            PlotOrientation.VERTICAL,  // orientation
            true,                      // include legend
            true,                      // tooltips
            false                      // urls
        );
	
	NsimoObject.setBackgroundPaint(Color.white);

	CategoryPlot plot = NsimoObject.getCategoryPlot();
        plot.setForegroundAlpha(0.7f);
        
        plot.setBackgroundPaint(Color.lightGray);
        plot.setDomainGridlinesVisible(true);
        plot.setDomainGridlinePaint(Color.white);
        plot.setRangeGridlinesVisible(true);
        plot.setRangeGridlinePaint(Color.white);


	int width=640; 
                int height=480; 
                File NsimoChart=new File("line02XML.png");              
                ChartUtilities.saveChartAsPNG(NsimoChart,NsimoObject,width,height); 
                }               
    }

