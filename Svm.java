package kernel;

import java.io.BufferedWriter;

import java.io.FileWriter;
import java.io.PrintWriter;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.LibSVM;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import wlsvm.WLSVM;
public class Svm {

	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		FileWriter file=new FileWriter("/home/debojyoti/nlp/report.csv");
		Instances tr=DataSource.read("/home/debojyoti/nlp/train_labelled.csv");
		Instances tst=DataSource.read("/home/debojyoti/nlp/train_labelled.csv");

		BufferedWriter bw=new BufferedWriter(file);
		PrintWriter out=new PrintWriter(bw);
		
		tr.setClassIndex(tr.numAttributes()-1);
		tst.setClassIndex(tst.numAttributes()-1);
		//WLSVM lsvm=new WLSVM();
		LibSVM lsvm=new LibSVM();
		String[] options=new String[10];
		options[8]="-K";				//setting kernel type, 1 for Polynomial Kernel
		options[9]="1";
		options[6]="-Z";				//normalization on
		options[7]="1";
		options[0]="-M";				//cache memory size in MB
		options[1]="80";
		for(int i = 1;i<=3;i++)
		{
			options[2]="-D";			//setting degree of polynomial
			options[3]=""+i;
			for(int j=10;j<=500;j=j+20)
			{
				options[4]="-C";		//set C of c-SVC
				options[5]=""+j;
				lsvm.setOptions(options);
				lsvm.buildClassifier(tr);
				Evaluation eval=new Evaluation(tr);
				//eval.crossValidateModel(lsvm,tr,5,new Random(1));
				eval.evaluateModel(lsvm, tst);
				System.out.println(i+","+j+","+eval.errorRate());
				System.out.println(eval.toSummaryString());
				//System.out.println(eval.toSummaryString("Results\n",false));
				out.println(i+","+j+","+eval.errorRate());
			}			
		}	
		out.close();
		bw.close();
		file.close();
	}

}
