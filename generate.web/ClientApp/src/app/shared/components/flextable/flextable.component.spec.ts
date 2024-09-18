import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FlextableComponent } from './flextable.component';

describe('FlextableComponent', () => {
  let component: FlextableComponent;
  let fixture: ComponentFixture<FlextableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FlextableComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(FlextableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
