/*
export JAVA_HOME=/usr/share/java
export CLASSPATH=$CLASSPATH:/home/mart/test2/jar/jcommon-1.0.17.jar:/home/mart/test2/jar/jfreechart-1.0.14.jar
*/
import java.io.*;
import org.jfree.data.category.DefaultCategoryDataset; 
import org.jfree.chart.ChartFactory; 
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.JFreeChart; 
import org.jfree.chart.ChartUtilities; 
import org.jfree.data.xml.DatasetReader;
import java.io.InputStream;
public class BarChartXMLExample {  
        
        public static void main(String[] args) throws Exception{
		/* Il root del file *.xml deve essere <CategoryDataset> */
		/* L'associazione dei colori (legenda) è espressa nell'item <Series>
		 * appena successivo al root: 
		 *   <Series name = "Marks in Various Subjects"> 
		 *   In alternativa, l'associazione si può esprimere nella prossima sezione
		 *   'create the chart', ma qui non ha senso esprimerla perché è monocolore.
		 *    Vedi l'esempio <PieChart...> per capire quando serve invece.*/
                DefaultCategoryDataset my_bar_chart_dataset = new DefaultCategoryDataset();
                File my_file=new File("prova.xml");           
                my_bar_chart_dataset = (DefaultCategoryDataset) DatasetReader.readCategoryDatasetFromXML(my_file);
                JFreeChart BarChartObject=ChartFactory.createBarChart("Subject Vs Marks - Bar Chart","Subject","Marks",my_bar_chart_dataset,PlotOrientation.VERTICAL,true,true,false);                  
                int width=640; 
                int height=480;                
                File BarChart=new File("XML2Chart.png");              
                ChartUtilities.saveChartAsPNG(BarChart,BarChartObject,width,height); 
                }               
        }

