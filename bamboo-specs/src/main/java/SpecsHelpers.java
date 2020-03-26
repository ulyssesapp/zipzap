import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class SpecsHelpers {
	public static String file(String fileName) {
		InputStream inputStream = SpecsHelpers.class.getClassLoader().getResourceAsStream(fileName);
		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
		StringBuilder stringBuilder = new StringBuilder();
		
		try {
			String line = bufferedReader.readLine();

			while (line != null) {
				stringBuilder.append(line).append("\n");
				line = bufferedReader.readLine();
			}
			
			bufferedReader.close();
		}

		catch (IOException e) {
			return "";
		}

		return stringBuilder.toString();
	}
}
