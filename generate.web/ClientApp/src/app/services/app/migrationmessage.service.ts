import { Injectable } from '@angular/core';
declare let moment: any;

@Injectable()
export class MigrationMessageService {


    getStatusMessage(lastMigrationHistoryDate, lastMigrationDurationInSeconds, userName, lastRunfactTypeMessage) {


        let message = '';

        if (lastMigrationDurationInSeconds != null) {

            let durationInMinutes = Math.round(lastMigrationDurationInSeconds / 60);

            if (lastMigrationHistoryDate != null) {

                let lastMigrationHistoryDateUtc = moment.utc(lastMigrationHistoryDate).toDate();
                let lastMigrationHistoryDateLocal = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a');

                if (durationInMinutes <= 1) {
                    message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' at ' + lastMigrationHistoryDateLocal + ', and processed successfully in ' + lastMigrationDurationInSeconds + ' seconds.';
                } else {
                    message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' at ' + lastMigrationHistoryDateLocal + ', and processed successfully in ' + durationInMinutes + ' minutes.';
                }

            } else {
                if (durationInMinutes <= 2) {
                    message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' and was processed successfully in under 2 minutes.';
                } else {
                    message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' and processed successfully in ' + durationInMinutes + ' minutes.';
                }
            }

        } else {
            if (lastMigrationHistoryDate != null) {
                let lastMigrationHistoryDateUtc = moment.utc(lastMigrationHistoryDate).toDate();
                let lastMigrationHistoryDateLocal = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a');
                message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' at ' + lastMigrationHistoryDateLocal + ', and processed successfully.';
            } else {
                message = 'Last migration was initiated ' + userName + lastRunfactTypeMessage + ' and processed successfully.';
            }
        }

        return message;

    }
}
