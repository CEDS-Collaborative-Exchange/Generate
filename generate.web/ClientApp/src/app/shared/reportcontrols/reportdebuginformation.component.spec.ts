import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportdebuginformationComponent } from './reportdebuginformation.component';

describe('ReportdebuginformationComponent', () => {
  let component: ReportdebuginformationComponent;
  let fixture: ComponentFixture<ReportdebuginformationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReportdebuginformationComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ReportdebuginformationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
