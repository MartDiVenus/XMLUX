/*
export JAVA_HOME=/usr/share/java
export CLASSPATH=$CLASSPATH:/home/mart/test2/jar/jcommon-1.0.17.jar:/home/mart/test2/jar/jfreechart-1.0.14.jar
*/
/*
 * I modo (da Java 11 in poi):
 * java PieChartXML.java
 * II modo (pre Java 11)
 * javac PieChartXML.java
 * java PieChartXML
 *
/* This example tutorial demonstrates how to draw and assign automatic 
 * coloration to a Pie chart Using JFreeChart Java API */
import java.io.*;
import org.jfree.data.general.DefaultPieDataset; /* This class is required to define the data for our Pie Chart */
import org.jfree.chart.ChartFactory; /* This class creates the Pie Chart for us */
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PiePlot; /* To change pie chart colors */
import org.jfree.chart.ChartUtilities; /* To write the Chart as JPG image file */
import java.awt.Color; /* To specify the color coordinates for the pie chart */
import org.jfree.data.xml.DatasetReader;
public class PieChartXML {  
     public static void main(String[] args){
        try {
               		/* Il root del file *.xml deve essere <PieDataset> */
                DefaultPieDataset my_Pie_Chart_dataset = new DefaultPieDataset();
	        File my_file=new File("prova.xml");           
                my_Pie_Chart_dataset = (DefaultPieDataset) DatasetReader.readPieDatasetFromXML(my_file);
	
                /* In mancanza dell'XML: 
		 * Define Values for the Pie Chart - Programming Languages Percentage Difficulty */
	       	/* A data range is required to create a Pie Chart in JFreeChart. 
		 * So, we will begin with defining a data range using the code below */
                //my_Pie_Chart.setValue("Java", 12.9);
                //my_Pie_Chart.setValue("C++", 37.9);
                //my_Pie_Chart.setValue("C", 86.5);
                //my_Pie_Chart.setValue("VB", 80.5);
                //my_Pie_Chart.setValue("Shell Script", 19.5);
                /* With the dataset defined for Pie Chart, we can invoke a method in ChartFactory object to create Pie Chart and Return a JFreeChart object*/
                /* This method returns a JFreeChart object back to us */                
                JFreeChart myColoredChart=ChartFactory.createPieChart(
				"Programming - Colored Pie Chart Example", // title
				my_Pie_Chart_dataset, // data
				true,
				true,
				false);                
                /*+ Once we have got the JFreeChart object, it is time to change the default colors for the Pie Chart */
                /*+ PiePlot class helps to change the colors for us, defined in org.jfree.chart.plot.PiePlot */
                /*+ getPlot method of JFreeChart class returns the PiePlot object back to us */                
                /*PiePlot ColorConfigurator = (PiePlot)myColoredChart.getPlot();*/
                /*+ We can now use setSectionPaint method to change the color of our chart */
                /*ColorConfigurator.setSectionPaint("Java", new Color(160, 160, 255));
                /*ColorConfigurator.setSectionPaint("C++", Color.ORANGE);
                /*ColorConfigurator.setSectionPaint("PHP", Color.GREEN);
                /*ColorConfigurator.setSectionPaint("python", Color.PINK);
                /*+ We will now write the chart as a JPEG file. 
		 *+ To do this we will use the ChartUtilities class. org.jfree.chart.ChartUtilities */                
                int width=640; /* Width of the image */
                int height=480; /* Height of the image */
                /*+ Note on Chart Quality Factor : java.lang.IllegalArgumentException: 
		 *+ The 'quality' must be in the range 0.0f to 1.0f */
                float quality=1; /* Quality factor */
                File PieChart=new File("my_pie_chart.jpg");
                /*+ Convert JFreeChart to JPEG File Using Code below */
                ChartUtilities.saveChartAsJPEG(PieChart, quality, myColoredChart,width,height); 
        }
        catch (Exception i)
        {
            System.out.println(i);
        }
    }
}

