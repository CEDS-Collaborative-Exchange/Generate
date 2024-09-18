export interface CedsElement {
  cedsElementId: number;
  cedsTermId: number;
  cedsElementName: string;
  cedsElementDefinition: string;
  cedsElementVersion: number;
  odsElements: Array<number>;
  cedsConnection_CedsElements: Array<number>;
}