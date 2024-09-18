import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PivottableComponent } from './pivottable.component';

describe('PivottableComponent', () => {
  let component: PivottableComponent;
  let fixture: ComponentFixture<PivottableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PivottableComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PivottableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
