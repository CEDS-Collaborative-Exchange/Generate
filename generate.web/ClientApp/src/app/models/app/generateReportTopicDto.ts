import { GenerateReportDto } from './generateReportDto';

export interface GenerateReportTopicDto {
    generateReportTopicId: number;
    generateReportTopicName: string;
    isActive: boolean;
    userName: string;
    generateReports: Array<GenerateReportDto>;
}