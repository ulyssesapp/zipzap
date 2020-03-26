import com.atlassian.bamboo.specs.api.BambooSpec;
import com.atlassian.bamboo.specs.api.builders.BambooKey;
import com.atlassian.bamboo.specs.api.builders.BambooOid;
import com.atlassian.bamboo.specs.api.builders.plan.Job;
import com.atlassian.bamboo.specs.api.builders.plan.Plan;
import com.atlassian.bamboo.specs.api.builders.plan.Stage;
import com.atlassian.bamboo.specs.api.builders.plan.branches.BranchCleanup;
import com.atlassian.bamboo.specs.api.builders.plan.branches.PlanBranchManagement;
import com.atlassian.bamboo.specs.api.builders.plan.configuration.ConcurrentBuilds;
import com.atlassian.bamboo.specs.api.builders.project.Project;
import com.atlassian.bamboo.specs.api.builders.requirement.Requirement;
import com.atlassian.bamboo.specs.builders.task.ScriptTask;
import com.atlassian.bamboo.specs.builders.task.TestParserTask;
import com.atlassian.bamboo.specs.builders.trigger.BitbucketServerTrigger;
import com.atlassian.bamboo.specs.builders.trigger.ScheduledTrigger;
import com.atlassian.bamboo.specs.model.task.ScriptTaskProperties;
import com.atlassian.bamboo.specs.model.task.TestParserTaskProperties;
import com.atlassian.bamboo.specs.util.BambooServer;

@BambooSpec
public class PlanSpec {
    
    public static Plan plan() {
        final Plan plan = new Plan(new Project()
                .oid(new BambooOid("1qtv4bzolewap"))
                .key(new BambooKey("LIBRARIES"))
                .name("Libraries"),
            "RTFKit",
            new BambooKey("RTFKIT"))
            .oid(new BambooOid("1qtlf4ebdlb0v"))
            .pluginConfigurations(new ConcurrentBuilds())
            .stages(new Stage("Default Stage")
                    .jobs(new Job("Default Job",
                            new BambooKey("JOB1"))
                            .tasks(new ScriptTask()
                                    .description("Test")
                                    .inlineBody(SpecsHelpers.file("test.sh")),
                                new ScriptTask()
                                    .description("Download Test Results")
                                    .location(ScriptTaskProperties.Location.FILE)
                                    .fileFromPath("/usr/local/bamboo/bin/downloadTestArtifacts.sh")
                                    .argument("test-reports"),
                                new TestParserTask(TestParserTaskProperties.TestType.JUNIT)
                                    .description("Parse Test Results")
                                    .resultDirectories("test-reports/merged.xml"))
                            .requirements(new Requirement("remotePort"),
                                new Requirement("remoteAddress"))))
            .linkedRepositories("RTFKit")
            
            .triggers(new BitbucketServerTrigger(),
                new ScheduledTrigger()
                    .cronExpression("0 0 4 ? * 1"))
            .planBranchManagement(new PlanBranchManagement()
                    .delete(new BranchCleanup())
                    .notificationForCommitters());
        return plan;
    }

    public static void main(String... argv) {
        //By default credentials are read from the '.credentials' file.
        BambooServer bambooServer = new BambooServer("https://ci.the-soulmen.com");
        
        final Plan plan = PlanSpec.plan();
        bambooServer.publish(plan);
    }
}