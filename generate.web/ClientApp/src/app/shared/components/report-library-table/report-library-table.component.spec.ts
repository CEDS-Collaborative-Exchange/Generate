import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportLibraryTableComponent } from './report-library-table.component';

describe('ReportLibraryTableComponent', () => {
  let component: ReportLibraryTableComponent;
  let fixture: ComponentFixture<ReportLibraryTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReportLibraryTableComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ReportLibraryTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
