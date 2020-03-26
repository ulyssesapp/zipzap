import com.atlassian.bamboo.specs.api.builders.plan.Plan;
import com.atlassian.bamboo.specs.api.util.EntityPropertiesBuilders;
import org.junit.Test;

public class PlanSpecTest {
    @Test
    public void checkYourPlanOffline() {
        Plan plan = PlanSpec.plan();

        EntityPropertiesBuilders.build(plan);
    }
}
