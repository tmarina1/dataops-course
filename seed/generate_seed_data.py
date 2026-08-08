import json
import random
from datetime import datetime, timedelta
from pathlib import Path

random.seed(42)


def encontrar_raiz_repositorio(inicio: Path) -> Path:
    for candidato in [inicio, *inicio.parents]:
        if (candidato / 'data').is_dir():
            return candidato
    raise RuntimeError(
        "No se encontró la raíz del repositorio con un directorio 'data/'. "
        f"Búsqueda iniciada en: {inicio}"
    )

repo_root = encontrar_raiz_repositorio(Path(__file__).resolve().parent)

data_dir = repo_root / 'data'

first_names = [
    'Ava','Noah','Liam','Emma','Olivia','Elijah','Sophia','Mia','Logan','Lucas',
    'Amelia','Ethan','Isabella','Mason','Harper','Evelyn','Jackson','Avery','Aiden','Scarlett'
]
last_names = [
    'Garcia','Smith','Johnson','Martinez','Brown','Davis','Lopez','Wilson','Anderson','Thomas',
    'Taylor','Moore','Jackson','Martin','Lee','Perez','Thompson','White','Harris','Sanchez'
]
streets = [
    'Maple St','Oak Ave','Pine Rd','Cedar Ln','Elm Ct','Birch Dr','Walnut Blvd','Ash St','Cherry Ave','Beech Rd'
]
cities = ['Springfield','Riverview','Fairview','Greenville','Lincoln','Madison','Georgetown','Clinton','Franklin','Salem']

roles = ['Mechanic','Service Advisor','Manager','Technician','Inspector']
service_names = [
    'Oil Change','Brake Inspection','Tire Rotation','Battery Replacement','Engine Tune-Up',
    'Wheel Alignment','AC Service','Transmission Check','Steering Repair','Coolant Flush',
    'Suspension Check','Exhaust Repair','Spark Plug Replacement','Filter Replacement','Brake Pad Replacement',
    'Transmission Fluid Change','Timing Belt Service','Fuel System Cleaning','Headlight Replacement','Windshield Wiper Service'
]
part_names = [
    'Brake Pad','Oil Filter','Air Filter','Spark Plug','Battery','Alternator','Headlight','Tail Light',
    'Timing Belt','Fuel Pump','Radiator Hose','Wheel Bearing','Starter Motor','Ignition Coil','Shock Absorber'
]
suppliers = ['ACME Auto','Precision Parts','Global Supply','Premier Components','DriveLine Inc.']
notes = [
    'Customer requested inspection.', 'Scheduled maintenance.', 'Follow-up on previous repair.',
    'Urgent service required.', 'Minor bodywork noted.', 'Warranty inspection.', 'Customer waiting for approval.',
    'Parts on backorder.', ''
]

vin_chars = 'ABCDEFGHJKLMNPRSTUVWXYZ0123456789'

def make_vin(idx):
    random.seed(idx)
    return ''.join(random.choice(vin_chars) for _ in range(17))


def make_customers(count=1000):
    customers = []
    for i in range(1, count+1):
        first = first_names[(i-1) % len(first_names)]
        last = last_names[(i-1) % len(last_names)]
        street = streets[(i-1) % len(streets)]
        city = cities[(i-1) % len(cities)]
        created_at = (datetime(2024,1,1) + timedelta(days=i % 365, seconds=(i*31)%86400)).isoformat(timespec='seconds')
        customers.append({
            'customer_id': i,
            'first_name': first,
            'last_name': last,
            'phone': f'+1-555-{1000 + i:04d}',
            'email': f'{first.lower()}.{last.lower()}{(i%100):02d}@example.com',
            'address': f'{100 + i % 900} {street}, {city}, CA',
            'created_at': created_at,
        })
    return customers


def make_vehicles(count=1200, customer_count=1000):
    makes = ['Toyota','Honda','Ford','Chevrolet','Nissan','BMW','Mercedes','Hyundai','Kia','Subaru']
    models = ['Corolla','Civic','F-150','Silverado','Altima','3 Series','C-Class','Elantra','Soul','Outback']
    vehicles = []
    for i in range(1, count+1):
        vid = ((i-1) % customer_count) + 1
        make = makes[(i-1) % len(makes)]
        model = models[(i-1) % len(models)]
        year = 2010 + (i % 15)
        vehicles.append({
            'vehicle_id': i,
            'customer_id': vid,
            'vin': make_vin(i),
            'make': make,
            'model': model,
            'year': year,
            'license_plate': f'{chr(65 + (i % 26))}{chr(65 + ((i//26)%26))}-{1000 + i%9000}',
            'mileage': 5000 + (i * 12) % 200000,
        })
    return vehicles


def make_employees(count=80):
    employees = []
    for i in range(1, count+1):
        first = first_names[(i*3 -1) % len(first_names)]
        last = last_names[(i*7 -1) % len(last_names)]
        hire_date = datetime(2015,1,1) + timedelta(days=(i * 14) % 3000)
        employees.append({
            'employee_id': i,
            'first_name': first,
            'last_name': last,
            'role': roles[i % len(roles)],
            'phone': f'+1-555-{2000 + i:04d}',
            'hire_date': hire_date.date().isoformat(),
            'hourly_rate': f'{30 + (i % 20) * 1.5:.2f}',
        })
    return employees


def make_services(count=40):
    services = []
    for i in range(1, count+1):
        name = service_names[(i-1) % len(service_names)]
        services.append({
            'service_id': i,
            'service_name': name,
            'description': f'{name} for light to moderate maintenance needs.',
            'standard_price': f'{50 + (i % 10) * 12:.2f}',
            'estimated_hours': f'{0.5 + (i % 5) * 0.5:.1f}',
        })
    return services


def make_parts(count=120):
    parts = []
    for i in range(1, count+1):
        name = part_names[(i-1) % len(part_names)]
        parts.append({
            'part_id': i,
            'part_name': f'{name} Kit' if i % 3 == 0 else name,
            'part_number': f'P{i:05d}',
            'unit_price': f'{10 + (i % 20) * 4:.2f}',
            'quantity_in_stock': 5 + (i * 3) % 95,
            'supplier': suppliers[(i-1) % len(suppliers)],
        })
    return parts


def make_work_orders(count=1200, vehicle_count=1200, employee_count=80):
    work_orders = []
    for i in range(1, count+1):
        vid = ((i-1) % vehicle_count) + 1
        status = ['Open','In Progress','Completed','Cancelled'][i % 4]
        open_date = datetime(2024, 1, 1) + timedelta(days=i % 365, hours=(i * 5) % 24)
        closed_date = None
        if status in ['Completed','Cancelled']:
            closed_date = open_date + timedelta(days=1 + (i % 7))
        employee = ((i-1) % employee_count) + 1 if status != 'Open' else None
        work_orders.append({
            'work_order_id': i,
            'vehicle_id': vid,
            'employee_id': employee,
            'status': status,
            'date_opened': open_date.isoformat(timespec='seconds'),
            'date_closed': closed_date.isoformat(timespec='seconds') if closed_date else None,
            'total_cost': f'{100 + (i % 20) * 15:.2f}',
            'notes': notes[i % len(notes)],
        })
    return work_orders


def make_work_order_items(order_count=1200, service_count=40, part_count=120):
    items = []
    item_id = 1
    for order_id in range(1, order_count+1):
        num_items = 2 + ((order_id + 1) % 4)
        for j in range(num_items):
            if (order_id + j) % 3 == 0:
                service_id = ((order_id + j - 1) % service_count) + 1
                part_id = None
                unit_price = 50 + (service_id % 10) * 10
            else:
                service_id = None
                part_id = ((order_id + j - 1) % part_count) + 1
                unit_price = 10 + (part_id % 20) * 2
            quantity = 1 + ((order_id + j) % 3)
            items.append({
                'item_id': item_id,
                'work_order_id': order_id,
                'service_id': service_id,
                'part_id': part_id,
                'quantity': quantity,
                'unit_price': f'{unit_price:.2f}',
            })
            item_id += 1
    return items

customers = make_customers(1000)
vehicles = make_vehicles(1200, 1000)
employees = make_employees(80)
services = make_services(40)
parts = make_parts(120)
work_orders = make_work_orders(1200, 1200, 80)
work_order_items = make_work_order_items(1200, 40, 120)

for name, records in [
    ('customers.json', customers),
    ('vehicles.json', vehicles),
    ('employees.json', employees),
    ('services.json', services),
    ('parts.json', parts),
    ('work_orders.json', work_orders),
    ('work_order_items.json', work_order_items),
]:
    path = data_dir / name
    path.write_text(json.dumps(records, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(f'Wrote {path} ({len(records)} records)')
