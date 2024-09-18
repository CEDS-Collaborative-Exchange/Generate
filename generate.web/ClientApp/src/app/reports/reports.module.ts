import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { SharedModule } from '../shared/shared.module';


// Routing
import { ReportsRoutingModule } from './reports-routing.module';


// Containers
import { ReportsComponent } from './reports.component';

// Pages
import { ReportsSummaryComponent } from './summary/reports-summary.component';
import { ReportsEdfactsComponent } from './edfacts/reports-edfacts.component';
import { ReportsSppaprComponent } from './sppapr/reports-sppapr.component';
import { ReportsLibraryComponent } from './library/reports-library.component';

// Child Components
import { ReportComponent } from '../shared/report.component';
import { FlexGridComponent } from '../shared/reportcontrols/flexgrid.component';
import { PivotGridComponent } from '../shared/reportcontrols/pivotgrid.component';
import { Indicator4aComponent } from '../shared/reportcontrols/indicator4a.component';
import { Indicator4bComponent } from '../shared/reportcontrols/indicator4b.component';
import { StudentCountComponent } from '../shared/reportcontrols/studentcount.component';
import { ExitSpecEdComponent } from '../shared/reportcontrols/exitspecialeducation.component';
import { CohortGradRateComponent } from '../shared/reportcontrols/cohortgraduationrate.component';
import { FederalProgramsParticipationComponent } from '../shared/reportcontrols/studentfederalprogramsparticipation.component';
import { MultipleFederalProgramsParticipationComponent } from '../shared/reportcontrols/studentmultiplefederalprogramsparticipation.component';
import { DisciplinaryRemovalsComponent } from '../shared/reportcontrols/disciplinaryremovals.component';
import { StateAssessmentsPerformanceComponent } from '../shared/reportcontrols/stateassessmentsperformance.component';
import { EdEnvironmentDisabilitiesage3To5Component } from '../shared/reportcontrols/edenvironmentdisabilitiesage3-5.component';
import { EdEnvironmentDisabilitiesage6To21Component } from '../shared/reportcontrols/edenvironmentdisabilitiesage6-21.component';
import { GradesOfferedComponent } from '../shared/reportcontrols/gradesoffered.component';
import { c029Component } from '../shared/reportcontrols/c029.component';
import { CCDSchoolComponent } from '../shared/reportcontrols/ccdschool.component';
import { LeaFederalFundComponent } from '../shared/reportcontrols/leafederalfund.component';
import { EarlyCharterComponent } from '../shared/reportcontrols/earlycharter.component';
import { CharterSchoolComponent } from '../shared/reportcontrols/charterschool.component';
import { C197Component } from '../shared/reportcontrols/c197.component';
import { C198Component } from '../shared/reportcontrols/c198.component';
import { C132Component } from '../shared/reportcontrols/c132.component';
import { C199Component } from '../shared/reportcontrols/c199.component';
import { C170Component } from '../shared/reportcontrols/c170.component';
import { C205Component } from '../shared/reportcontrols/c205.component';
import { C206Component } from '../shared/reportcontrols/c206.component';
import { C131Component } from '../shared/reportcontrols/c131.component';
import { C163Component } from '../shared/reportcontrols/c163.component';
import { C207Component } from '../shared/reportcontrols/c207.component';
import { C223Component } from '../shared/reportcontrols/c223.component';
import { YearToYearChildCountComponent } from '../shared/reportcontrols/yeartoyearchildcount.component';
import { YearToYearEnvironmentCountComponent } from '../shared/reportcontrols/yeartoyearenvironmentcount.component';
import { YearToYearExitCountComponent } from '../shared/reportcontrols/yeartoyearexitcount.component';
import { LeaStudentsProfileComponent } from '../shared/reportcontrols/leastudentsprofile.component';
import { YearToYearRemovalCountComponent } from '../shared/reportcontrols/yeartoyearremovalcount.component';
import { C035Component } from '../shared/reportcontrols/c035.component';
import { ReportsLibraryReportComponent } from './library/reports-library-report.component';
import { YeartoYearProgressComponent } from '../shared/reportcontrols/yeartoyearprogress.component';
import { YeartoYearAttendanceComponent } from '../shared/reportcontrols/yeartoyearattendance.component';

@NgModule({
    imports: [
        SharedModule,
        FormsModule,
        ReactiveFormsModule,
        ReportsRoutingModule
    ],
    declarations: [
        ReportsComponent,
        ReportsSummaryComponent,
        ReportsEdfactsComponent,
        ReportsSppaprComponent,
        ReportsLibraryComponent,
        ReportComponent,
        FlexGridComponent,
        PivotGridComponent,
        Indicator4aComponent,
        Indicator4bComponent,
        StudentCountComponent,
        ExitSpecEdComponent,
        CohortGradRateComponent,
        FederalProgramsParticipationComponent,
        MultipleFederalProgramsParticipationComponent,
        DisciplinaryRemovalsComponent,
        StateAssessmentsPerformanceComponent,
        EdEnvironmentDisabilitiesage3To5Component,
        EdEnvironmentDisabilitiesage6To21Component,
        GradesOfferedComponent,
        c029Component,
        CCDSchoolComponent,
        LeaFederalFundComponent,
        EarlyCharterComponent,
        CharterSchoolComponent,
        C197Component,
        C198Component,
        C132Component,
        C170Component,
        C205Component,
        C206Component,
        C131Component,
        C163Component,
        C207Component,
        C223Component,
        YearToYearChildCountComponent,
        YearToYearEnvironmentCountComponent,
        YearToYearExitCountComponent,
        C199Component,
        LeaStudentsProfileComponent,
        YearToYearRemovalCountComponent,
        C035Component,
        ReportsLibraryReportComponent,
        YeartoYearProgressComponent,
        YeartoYearAttendanceComponent
    ],
    exports: [
        ReportComponent,
        FlexGridComponent,
        PivotGridComponent,
        Indicator4aComponent,
        Indicator4bComponent,
        StudentCountComponent,
        ExitSpecEdComponent,
        CohortGradRateComponent,
        FederalProgramsParticipationComponent,
        MultipleFederalProgramsParticipationComponent,
        DisciplinaryRemovalsComponent,
        StateAssessmentsPerformanceComponent,
        EdEnvironmentDisabilitiesage3To5Component,
        EdEnvironmentDisabilitiesage6To21Component,
        GradesOfferedComponent,
        c029Component,
        CCDSchoolComponent,
        LeaFederalFundComponent,
        EarlyCharterComponent,
        CharterSchoolComponent,
        C197Component,
        C198Component,
        C132Component,
        C170Component,
        C205Component,
        C206Component,
        C131Component,
        C163Component,
        C207Component,
        C223Component,
        YearToYearChildCountComponent,
        YearToYearEnvironmentCountComponent,
        YearToYearExitCountComponent,
        C199Component,
        LeaStudentsProfileComponent,
        YearToYearRemovalCountComponent,
        C035Component,
        YeartoYearProgressComponent,
        YeartoYearAttendanceComponent

    ]
})
export class ReportsModule { }
