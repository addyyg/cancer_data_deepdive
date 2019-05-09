import datetime
from airflow import models
from airflow.operators.bash_operator import BashOperator
from airflow.operators.dummy_operator import DummyOperator

default_dag_args = {
    'start_date': datetime.datetime(2019, 4, 23)
}
###### SQL variables ###### 
raw_dataset = 'cancer_trials'
new_dataset = 'workflow'
sql_cmd_start = 'bq query --use_legacy_sql=false '

sql_arm= 'create table ' + new_dataset + '.Arm_Temp as ' \
           'from ' + raw_dataset + '.ArmGroup ' \
           'select distinct nct_number,arm_group_label,arm_group_type,description,serialid ' \
           'from cancer_trials.NIHClinicalTrials_Arm_Group' \
           'where arm_group_label like '%cancer%' or description like '%cancer%' '\
           'order by nct_number'

sql_location='create table ' + new_dataset + '.Location_Temp as ' \
           'from ' + raw_dataset + '.Location ' \
           'select distinct nct_number,facility_name,facility_city,facility_state,facility_country,serialid ' \
           'from cancer_trials.NIHClinicalTrials_Location ' \
           'where facility_country == \'United States\' '\
           'and nct_number is not null '\
           'order by nct_number'

sql_primary = 'create table ' + new_dataset + '.Primary_Temp as ' \
           'from ' + raw_dataset + '.ArmGroup ' \
           'select distinct nct_number,measure,time_frame,description,serialid ' \
           'from cancer_trials.NIHClinicalTrials_Primary_Outcomes' \
           'where measure is not null'\
           'order by nct_number'

sql_secondary= 'create table ' + new_dataset + '.Secondary_Temp as ' \
           'from ' + raw_dataset + '.ArmGroup ' \
           'select distinct nct_number,measure,time_frame,description,serialid ' \
           'from cancer_trials.NIHClinicalTrials_Secondary_Outcomes' \
           'where measure is not null'\
           'order by nct_number'

###### Beam variables ######          
LOCAL_MODE=1 # run beam jobs locally
DIST_MODE=2 # run beam jobs on Dataflow

mode=LOCAL_MODE

if mode == LOCAL_MODE:
    main_script = 'transform_trials_main_single.py'
    
if mode == DIST_MODE:
    main_script = 'transform_trials_main_single.py'

###### DAG section ###### 
with models.DAG(
        'workflow',
        schedule_interval=datetime.timedelta(days=1),
        default_args=default_dag_args) as dag:
    ###### SQL tasks ######
    delete_dataset = BashOperator(
            task_id='delete_dataset',
            bash_command='bq rm -r -f workflow')
                
    create_dataset = BashOperator(
            task_id='create_dataset',
            bash_command='bq mk workflow')
    
    create_arm_table = BashOperator(
            task_id='create_arm_table',
            bash_command=sql_cmd_start + '"' + sql_arm + '"')
    
    create_primary_table = BashOperator(
            task_id='create_primary_table',
            bash_command=sql_cmd_start + '"' + sql_primary + '"')
    
    create_secondary_table = BashOperator(
            task_id='create_arm_table',
            bash_command=sql_cmd_start + '"' + sql_secondary + '"')  
    
    create_location_table = BashOperator(
            task_id='create_location_table',
            bash_command=sql_cmd_start + '"' + sql_location + '"')    
    
    ###### Beam tasks ######     
    main_beam = BashOperator(
            task_id='main_beam',
            bash_command='python /Users/adhiesp/airflow/dags/' + main_script)

    transition = DummyOperator(task_id='transition')
            
    delete_dataset >> create_dataset >> [main_beam]>> transition
    transition >> [create_arm_table, create_primary_table, create_secondary_table, create_location_table]
    
